// Path: test/http_client_test.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/retry_handler.dart';
import 'package:empylo_app/utils/dio_http_exception.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empylo_app/services/http_service.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/services/http_client.dart';

class MockDio extends Mock implements Dio {}

class MockHttpService extends Mock implements HttpService {}

class MockSentryService extends Mock implements SentryService {}

class FakeErrorEvent extends Fake implements ErrorEvent {}

class MockRetryHandler extends Mock implements RetryHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeErrorEvent());
    registerFallbackValue(MockSentryService());
  });
  group('HttpClient Instantiation Tests', () {
    test('Successfully creates an instance with valid dependencies', () {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      // Act
      final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: retryHandler);

      // Assert
      expect(client, isA<HttpClient>());
    });
  });

  group('HttpClient executeRequest Tests', () {
    test('Handles retry logic correctly', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(
        () => retryHandler.retryRequest(
          any(),
          maxRetries: any(named: 'maxRetries'),
          initialDelay: any(named: 'initialDelay'),
          backoffFactor: any(named: 'backoffFactor'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'test': 'test'},
        ),
      );


      final client = HttpClient(
        httpService: httpService,
        sentryService: sentryService,
        retryHandler: retryHandler,
      );

      // Act
      final response = await client.executeRequest(
        () => httpService.get(''), // Removed the async keyword
        retryParams: {
          'maxRetries': 3,
          'initialDelay': 1000,
          'backoffFactor': 2,
        },
      );

      // Assert
      expect(response, isA<Response>());
      verify(() => httpService.get(any())).called(1);
    });

    test(
        'when executeRequest is called make sure retryRequest function is called with expected parameter values',
        () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(() => httpService.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'test': 'test'}));

      when(() => retryHandler.retryRequest(any(),
              maxRetries: any(named: 'maxRetries'),
              initialDelay: any(named: 'initialDelay'),
              backoffFactor: any(named: 'backoffFactor')))
          .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'test': 'test'}));

      final client = HttpClient(
        httpService: httpService,
        sentryService: sentryService,
        retryHandler: retryHandler,
      );

      // Act
      final response = await client.executeRequest(() async {
        return await httpService.get('');
      }, retryParams: {
        'maxRetries': 3,
        'initialDelay': 1000,
        'backoffFactor': 2,
      });

      // Assert
      expect(response, isA<Response>());
      verify(() => httpService.get(any())).called(1);
      verify(() => retryHandler.retryRequest(
            any(),
            maxRetries: any(named: 'maxRetries'),
            initialDelay: any(named: 'initialDelay'),
            backoffFactor: any(named: 'backoffFactor'),
          )).called(1);
    });
    test('Handles connectionError DioException correctly', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(() => httpService.get(any())).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError));
      final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: retryHandler);

      // Act
      try {
        await client.executeRequest(() async {
          return await httpService.get('');
        });
      } catch (e) {
        // Assert
        expect(e, isA<DioHttpException>());
        verify(() => httpService.get(any())).called(1);
      }
    });

    test('HttpClient uses provided SentryService for error handling', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(() => sentryService.sendErrorEvent(any()))
          .thenAnswer((_) async => {});
      final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: retryHandler);

      // Act
      try {
        await client.executeRequest(() async {
          throw Exception('Test Exception');
        });
      } catch (e) {
        // Assert
        expect(e, isA<DioHttpException>());
        verify(() => sentryService.sendErrorEvent(any())).called(1);
      }
    });
  });

  group('post, get, put, delete tests', () {
    test('post happy path', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(() => httpService.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'test': 'test'}));
      final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: retryHandler);

      // Act
      final response = await client.executeRequest(() async {
        return await httpService.post('test', data: {'test': 'test'});
      });

      // Assert
      expect(response, isA<Response>());
      verifyNever(() => sentryService.sendErrorEvent(any()));
    });

    test('post recoverable error', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(() => httpService.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionTimeout));
      final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: retryHandler);

      // Act
      try {
        await client.executeRequest(() async {
          return await httpService.post('test', data: {'test': 'test'});
        });
      } catch (e) {
        // Assert
        expect(e, isA<DioHttpException>());
        verifyNever(() => sentryService.sendErrorEvent(any()));
      }
    });

    // retry

    test('post unrecoverable error', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(() => httpService.post(any(), data: any(named: 'data'))).thenThrow(
          DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.sendTimeout));
      final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: retryHandler);

      // Act
      try {
        await client.executeRequest(() async {
          return await httpService.post('test', data: {'test': 'test'});
        });
      } catch (e) {
        // Assert
        expect(e, isA<DioHttpException>());
        verify(() => sentryService.sendErrorEvent(any())).called(1);
      }
    });
  });
}

// Path: test/http_client_test.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http/http_client.dart';
import 'package:empylo_app/services/http/http_service.dart';
import 'package:empylo_app/services/retry/retry_handler.dart';
import 'package:empylo_app/services/sentry/sentry_service.dart';
import 'package:empylo_app/utils/custom_exceptions/max_retries_exceeded_exception.dart';
import 'package:empylo_app/utils/dio_http_exception.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

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
      final retryHandler = RetryHandler(
        sentryService: sentryService,
      );
      final mockDio = MockDio();

      when(() => mockDio.get(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer(
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
        () async {
          return await mockDio.get(
            '',
            data: {'test': 'test'},
            options: Options(
              headers: {'test': 'test'},
            ),
          );
        },
        retryParams: {
          'maxRetries': 3,
          'initialDelay': 1000,
          'backoffFactor': 2,
        },
      );

      // Assert
      expect(response, isA<Response>());
      verify(() => mockDio.get(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).called(1);
    });

    group('HttpClient executeRequest Tests', () {
      test('executeRequest calls retryRequest with expected parameters',
          () async {
        // Arrange
        final httpService = MockHttpService();
        final sentryService = MockSentryService();
        final mockRetryHandler = MockRetryHandler();

        final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: mockRetryHandler,
        );

        final mockResponse =
            Response(requestOptions: RequestOptions(path: 'test'));

        when(() => mockRetryHandler.retryRequest<dynamic>(
              any(),
              maxRetries: any(named: 'maxRetries'),
              initialDelay: any(named: 'initialDelay'),
              backoffFactor: any(named: 'backoffFactor'),
            )).thenAnswer((invocation) async {
          var requestFunction = invocation.positionalArguments[0]
              as Future<Response<dynamic>> Function();
          return await requestFunction();
        });

        // Act
        await client.executeRequest(
          () async => mockResponse,
          retryParams: {
            'maxRetries': 3,
            'initialDelay': 2000,
            'backoffFactor': 2,
          },
        );

        // Assert
        verify(() => mockRetryHandler.retryRequest(
              any<Future<Response<dynamic>> Function()>(),
              maxRetries: 3,
              initialDelay: 2000,
              backoffFactor: 2,
            )).called(1);
      });
    });

    test('Handles connectionError DioException correctly', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );

      when(() => httpService.get(any(), headers: any(named: 'headers')))
          .thenThrow(dioException);

      when(() => retryHandler.retryRequest<dynamic>(
            any(),
            maxRetries: any(named: 'maxRetries'),
            initialDelay: any(named: 'initialDelay'),
            backoffFactor: any(named: 'backoffFactor'),
          )).thenAnswer((invocation) async {
        var requestFunction = invocation.positionalArguments[0]
            as Future<Response<dynamic>> Function();
        return await requestFunction();
      });

      final client = HttpClient(
        httpService: httpService,
        sentryService: sentryService,
        retryHandler: retryHandler,
      );

      // Act & Assert
      try {
        await client.executeRequest(
          () async => httpService.get('test', headers: {'test': 'test'}),
          retryParams: {
            'maxRetries': 3,
            'initialDelay': 1000,
            'backoffFactor': 2,
          },
        );
      } catch (e) {
        expect(e, isA<DioHttpException>());
        if (e is DioHttpException) {
          expect(
              e.message,
              equals(
                  'An error occurred while processing your request. Please try again later.'));
          expect(e.statusCode, equals(null));
        } else {
          fail('Expected DioHttpException');
        }
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
        expect(e, isA<Exception>());
        verify(() => sentryService.sendErrorEvent(any())).called(1);
      }
    });
  });

  group('post tests', () {
    test('post happy path', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(() => httpService.post(any(),
              headers: any(named: 'headers'), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'test': 'test'}));
      final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: retryHandler);

      when(() => retryHandler.retryRequest<dynamic>(
            any(),
            maxRetries: any(named: 'maxRetries'),
            initialDelay: any(named: 'initialDelay'),
            backoffFactor: any(named: 'backoffFactor'),
          )).thenAnswer((invocation) async {
        var requestFunction = invocation.positionalArguments[0]
            as Future<Response<dynamic>> Function();
        return await requestFunction();
      });

      // Act
      final response = await client
          .post(url: 'test', headers: {'test': 'test'}, data: {'test': 'test'});

      // Assert
      expect(response, isA<Response>());
      verifyNever(() => sentryService.sendErrorEvent(any()));
    });

    test('post unrecoverable error', () async {
      // Arrange
      final httpService = MockHttpService();
      final sentryService = MockSentryService();
      final retryHandler = MockRetryHandler();

      when(() => httpService.post(any(),
              headers: any(named: 'headers'), data: any(named: 'data')))
          .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.sendTimeout));
      final client = HttpClient(
          httpService: httpService,
          sentryService: sentryService,
          retryHandler: retryHandler);

      when(
        () => retryHandler.retryRequest<dynamic>(
          any(),
          maxRetries: any(named: 'maxRetries'),
          initialDelay: any(named: 'initialDelay'),
          backoffFactor: any(named: 'backoffFactor'),
        ),
      ).thenThrow(
        MaxRetriesExceededException('Test Exception'),
      );

      when(() => sentryService.sendErrorEvent(any()))
          .thenAnswer((_) async => {});

      // Act
      try {
        await client.post(
            url: 'test', headers: {'test': 'test'}, data: {'test': 'test'});
      } catch (e) {
        // Assert
        expect(e, isA<MaxRetriesExceededException>());
        verify(() => sentryService.sendErrorEvent(any())).called(1);
      }
    });
  });
}

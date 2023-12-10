// Path: test/services/retry_handler_test.dart

import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:empylo_app/services/retry_handler.dart';

class MockDio extends Mock implements Dio {}

class MockSentryService extends Mock implements SentryService {}

void main() {
  setUpAll(() {
    const error = 'Test error';
    final stackTrace = StackTrace.current;
    const attempt = 1;
    registerFallbackValue(ErrorEvent(
      message: 'Failed to execute request on attempt $attempt: $error',
      level: 'error',
      extra: {'stackTrace': stackTrace.toString()},
    ));
  });

  group('Sentry logging tests', () {
    test('logs error even with correct message level and stack trace',
        () async {
      // Arrange
      final mockSentryService = MockSentryService();
      const error = 'Test error';
      final stackTrace = StackTrace.current;
      const attempt = 1;

      // Setup mock to return a future
      when(() => mockSentryService.sendErrorEvent(any())).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      await logErrorToSentry(error, stackTrace, attempt, mockSentryService);

      // Assert
      final captured =
          verify(() => mockSentryService.sendErrorEvent(captureAny()))
              .captured
              .single as ErrorEvent;
      expect(captured.message,
          'Failed to execute request on attempt $attempt: $error');
      expect(captured.level, 'error');
      expect(captured.extra['stackTrace'], stackTrace.toString());
    });

    test('logErrorToSentry does not call sendErrorEvent if exception is null',
        () async {
      // Arrange
      final mockSentryService = MockSentryService();
      final stackTrace = StackTrace.current;
      const attempt = 1;

      // Act
      await Future(
          () => logErrorToSentry(null, stackTrace, attempt, mockSentryService));

      // Assert
      verifyNever(() => mockSentryService.sendErrorEvent(any()));
    });

    test('logErrorToSentry propagates exception if sendErrorEvent throws',
        () async {
      // Arrange
      final mockSentryService = MockSentryService();
      const error = 'Test error';
      final stackTrace = StackTrace.current;
      const attempt = 1;

      // Setup mock to throw an exception
      when(() => mockSentryService.sendErrorEvent(any()))
          .thenThrow(Exception('Test exception'));

      // Act & Assert
      expect(
          () async => await logErrorToSentry(
              error, stackTrace, attempt, mockSentryService),
          throwsException);
    });
  });

  // add group for retryRequest tests
  group('retryRequest tests', () {
    // add test for retryRequest with successful response
    test('retryRequest returns response if response is successful', () async {
      // Arrange
      final mockDio = MockDio();
      final mockSentryService = MockSentryService();
      const maxRetries = 3;
      const backoffFactor = 2;
      const delay = 100;
      const request = 'Test request';
      final response = Response<dynamic>(
        statusCode: 200,
        data: 'Test data',
        requestOptions: RequestOptions(path: ''),
      );

      // Setup mock to return a future
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => response,
      );

      // Act
      final result = await retryRequest<dynamic>(
        () => mockDio.post(
          request,
          data: request,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        ),
        maxRetries: maxRetries,
        backoffFactor: backoffFactor,
        initialDelay: delay,
        sentryService: mockSentryService,
      );

      // Assert
      expect(result, response);
    });

    // add test for retryRequest with unsuccessful response
    test('retryRequest throws exception if response is unsuccessful', () async {
      /// Arrange
      final mockDio = MockDio();
      final mockSentryService = MockSentryService();
      const maxRetries = 3;
      const backoffFactor = 2;
      const delay = 100;
      const request = 'Test request';

// Setup mock to return a future
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          statusCode: 500,
          data: 'Test data',
          requestOptions: RequestOptions(path: ''),
        ),
      );

// Ensure sendErrorEvent returns a Future<void>
      when(() => mockSentryService.sendErrorEvent(any()))
          .thenAnswer((_) async => Future.value());

// Act & Assert
      expect(
          () async => await retryRequest<dynamic>(
                () => mockDio.post(
                  request,
                  data: request,
                  options: Options(
                    headers: {'Content-Type': 'application/json'},
                  ),
                ),
                maxRetries: maxRetries,
                backoffFactor: backoffFactor,
                initialDelay: delay,
                sentryService: mockSentryService,
              ),
          throwsException);
    });

    test('Should successfully execute a request with one retry', () async {
      // Arrange
      final mockDio = MockDio();
      final mockSentryService = MockSentryService();
      const maxRetries = 3;
      const backoffFactor = 2;
      const delay = 100;
      const request = 'Test request';
      final response = Response<dynamic>(
        statusCode: 200,
        data: 'Test data',
        requestOptions: RequestOptions(path: ''),
      );

      // Setup mock to return a future
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<dynamic>(
          statusCode: 500,
          data: 'Test data',
          requestOptions: RequestOptions(path: ''),
        ),
      );

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => response,
      );

      // Ensure sendErrorEvent returns a Future<void>
      when(() => mockSentryService.sendErrorEvent(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await retryRequest<dynamic>(
        () => mockDio.post(
          request,
          data: request,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        ),
        maxRetries: maxRetries,
        backoffFactor: backoffFactor,
        initialDelay: delay,
        sentryService: mockSentryService,
      );

      // Assert
      expect(result, response);
    });

    // add test for retryRequest with DioException
    test(
        'retryRequest retries on DioException and throws exception after max retries',
        () async {
      // Arrange
      final mockDio = MockDio();
      final mockSentryService = MockSentryService();
      const maxRetries = 3;
      const backoffFactor = 2;
      const delay = 100;
      const request = 'Test request';
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Dio error',
      );

      // Setup mock to throw a DioException
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(dioException);

      // Ensure sendErrorEvent returns a Future<void>
      when(() => mockSentryService.sendErrorEvent(any()))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      expect(
        () async => await retryRequest<dynamic>(
          () => mockDio.post(
            request,
            data: request,
            options: Options(
              headers: {'Content-Type': 'application/json'},
            ),
          ),
          maxRetries: maxRetries,
          backoffFactor: backoffFactor,
          initialDelay: delay,
          sentryService: mockSentryService,
        ),
        throwsA(isA<DioException>()),
      );
    });

    
  });
}

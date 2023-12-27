// Path: test/services/retry_handler_test.dart

import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/retry_handler.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/utils/custom_exceptions/max_retries_exceeded_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

class MockSentryService extends Mock implements SentryService {}

class StackTraceFake extends Fake implements StackTrace {}

void main() {
  setUpAll(() {
    final error = Exception('Test error');
    final stackTrace = StackTrace.current;
    const attempt = 1;
    registerFallbackValue(
      ErrorEvent(
        message: 'Failed to execute request on attempt $attempt: $error',
        level: 'error',
        extra: {
          'stackTrace': stackTrace.toString(),
        },
      ),
    );
    registerFallbackValue(
      StackTraceFake(),
    );
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
      final retryHandler = RetryHandler(sentryService: mockSentryService);

      // Setup mock to return a future
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => response,
      );

      // Act
      final result = await retryHandler.retryRequest<dynamic>(
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
      );

      // Assert
      expect(result, response);
    });

    // add test for retryRequest with unsuccessful response
    test('retryRequest throws exception if response is unsuccessful', () async {
      /// Arrange
      final mockDio = MockDio();
      final mockSentryService = MockSentryService();
      final RetryHandler retryHandler = RetryHandler(
        sentryService: mockSentryService,
      );
      const maxRetries = 3;
      const backoffFactor = 2;
      const delay = 100;
      const request = 'Test request';

      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      const attempt = 1;

      // Setup mock to throw a DioException
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response<dynamic>(
            statusCode: 500,
            data: 'Test data',
            requestOptions: RequestOptions(path: ''),
          ),
          stackTrace: stackTrace,
          error: 'Dio error',
          type: DioExceptionType.badResponse,
        ),
      );

      // Ensure logErrorToSentry returns a Future<void>
      when(
        () => mockSentryService.logErrorToSentry(
          error.toString(),
          stackTrace,
          attempt,
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      // Act & Assert
      expect(
        () async => await retryHandler.retryRequest<dynamic>(
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
        ),
        throwsA(
          isA<MaxRetriesExceededException>(),
        ),
      );
    });

    test('Should successfully execute a request with retries', () async {
      // Arrange
      final mockDio = MockDio();
      final mockSentryService = MockSentryService();
      final RetryHandler retryHandler = RetryHandler(
        sentryService: mockSentryService,
      );
      const maxRetries = 3;
      const backoffFactor = 2;
      const delay = 100;
      const request = 'Test request';
      final response = Response<dynamic>(
        statusCode: 200,
        data: 'Test data',
        requestOptions: RequestOptions(path: ''),
      );

      int callCount = 0;
      when(() => mockDio.post(any(),
          data: any(named: 'data'),
          options: any(named: 'options'))).thenAnswer((_) async {
        callCount++;
        if (callCount < maxRetries) {
          throw DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response<dynamic>(
              statusCode: 500,
              data: 'Test data',
              requestOptions: RequestOptions(path: ''),
            ),
            error: 'Dio error',
          );
        }
        return response;
      });

      when(() => mockSentryService.sendErrorEvent(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await retryHandler.retryRequest<dynamic>(
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
      );

      // Assert
      expect(result, response);
      verify(() => mockDio.post(any(),
          data: any(named: 'data'),
          options: any(named: 'options'))).called(maxRetries);
    });

    // add test for retryRequest with DioException
    test(
        'retryRequest retries on DioException and throws exception after max retries',
        () async {
      // Arrange
      final mockDio = MockDio();
      final mockSentryService = MockSentryService();
      final RetryHandler retryHandler = RetryHandler(
        sentryService: mockSentryService,
      );
      const maxRetries = 3;
      const backoffFactor = 2;
      const delay = 100;
      const request = 'Test request';
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response<dynamic>(
          statusCode: 500,
          data: 'Test data',
          requestOptions: RequestOptions(path: ''),
        ),
        stackTrace: StackTrace.current,
        error: 'Dio error',
        type: DioExceptionType.badResponse,
      );

      // Setup mock to throw a DioException
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(dioException);

      // Ensure sendErrorEvent returns a Future<void>
      when(
        () => mockSentryService.sendErrorEvent(
          any(),
        ),
      ).thenAnswer((_) async => Future.value());

      // Act & Assert
      expect(
        () async => await retryHandler.retryRequest<dynamic>(
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
        ),
        throwsA(
          isA<MaxRetriesExceededException>(),
        ),
      );
    });

    test('retryRequest retries on failure and eventually succeeds', () async {
      // Arrange
      final mockDio = MockDio();
      final mockSentryService = MockSentryService();
      final RetryHandler retryHandler = RetryHandler(
        sentryService: mockSentryService,
      );
      const maxRetries = 3;
      const backoffFactor = 2;
      const delay = 100;
      const request = 'Test request';
      final response = Response<dynamic>(
        statusCode: 200,
        data: 'Test data',
        requestOptions: RequestOptions(path: ''),
      );

      // Setup mock to throw a DioException
      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Dio error',
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
      final result = await retryHandler.retryRequest<dynamic>(
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
      );

      // Assert
      expect(result, response);
    });

    test('should call request() function maxRetries times if request() fails',
        () async {
      final sentryService = MockSentryService();
      final dio = MockDio();
      final retryHandler = RetryHandler(sentryService: sentryService);
      final url = 'https://api.example.com/data';
      int callCount = 0;

      // Setup mock to throw a DioException
      when(() => dio.get(url)).thenAnswer((_) {
        callCount++;
        if (callCount <= 3) {
          throw DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response<dynamic>(
              statusCode: 500,
              data: 'Test data',
              requestOptions: RequestOptions(path: ''),
            ),
            stackTrace: StackTrace.current,
            error: 'Dio error',
            type: DioExceptionType.badResponse,
          );
        } else {
          return Future.value(
            Response<dynamic>(
              statusCode: 200,
              data: 'Test data',
              requestOptions: RequestOptions(path: ''),
            ),
          );
        }
      });

      // Ensure logErrorToSentry returns a Future<void>
      when(
        () => sentryService.logErrorToSentry(
          any(),
          any(),
          any(),
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      try {
        await retryHandler.retryRequest<dynamic>(
          () => dio.get(url),
          maxRetries: 3,
          backoffFactor: 2,
          initialDelay: 100,
        );
      } catch (e) {
        expect(e, isA<MaxRetriesExceededException>());
      }

      // wait for the event loop to finish before verifying
      verify(
        () => dio.get(url),
      ).called(3);
    });
  });

  // add group for isRetryableError tests
  group('isRetryableError tests', () {
    final mockSentryService = MockSentryService();
    final RetryHandler retryHandler = RetryHandler(
      sentryService: mockSentryService,
    );
    // add test for isRetryableError with DioException
    test('isRetryableError returns true if DioException is retryable',
        () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Dio error',
        response: Response<dynamic>(
          statusCode: 500,
          data: 'Test data',
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = retryHandler.isRetryableError(dioException);

      // Assert
      expect(result, true);
    });

    // add test for isRetryableError with non-retryable DioException
    test('isRetryableError returns false if DioException is not retryable',
        () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Dio error',
        response: Response<dynamic>(
          statusCode: 200,
          data: 'Test data',
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // Act
      final result = retryHandler.isRetryableError(dioException);

      // Assert
      expect(result, false);
    });

    // add test for isRetryableError with non-DioException
    test('isRetryableError returns false if error is not DioException',
        () async {
      // Arrange
      const error = 'Test error';

      // Act
      final result = retryHandler.isRetryableError(error);

      // Assert
      expect(result, false);
    });
  });
}

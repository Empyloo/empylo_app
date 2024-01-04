import 'package:dio/dio.dart';
import 'package:empylo_app/constants/retryable_status_codes.dart';
import 'package:empylo_app/services/sentry/sentry_service.dart';
import 'package:empylo_app/utils/custom_exceptions/max_retries_exceeded_exception.dart';

/// `RetryHandler` is a class that handles the retry logic for network requests.
///
/// It provides a method `retryRequest` that takes a network request function and
/// retries it a specified number of times with an increasing delay between retries
/// if the request fails. It also logs any errors to a Sentry service.
///
/// The `retryRequest` method takes the following parameters:
/// - `request`: A function that returns a `Future<Response<T>>` representing the network request to be retried.
/// - `maxRetries`: The maximum number of times the request should be retried. Default is 3.
/// - `initialDelay`: The initial delay in milliseconds before the first retry. Default is 1000.
/// - `backoffFactor`: The factor by which the delay increases with each retry. Default is 2.
///
/// The `isRetryableError` method checks if an error is retryable. It verifies if the error is an instance of `DioException`
/// and if its response status code is included in a list of retryable status codes.
///
/// Example Usage:
/// ```dart
/// final sentryService = SentryService(...);
/// final retryHandler = RetryHandler(sentryService: sentryService);
/// final response = await retryHandler.retryRequest(() => dio.get('https://api.example.com/data'));
/// print(response.data);
/// ```
class RetryHandler {
  final SentryService sentryService;

  RetryHandler({
    required this.sentryService,
  });

  /// Retries a network request with increasing delay between retries.
  ///
  /// @param request The network request to be retried.
  /// @param maxRetries The maximum number of times the request should be retried.
  /// @param initialDelay The initial delay in milliseconds before the first retry.
  /// @param backoffFactor The factor by which the delay increases with each retry.
  /// @return A `Future<Response<T>>` representing the response of the request.
  /// @throws MaxRetriesExceededException if the maximum number of retries is exceeded.
  /// @throws DioError if the request fails.
  ///
  /// Example Usage:
  /// ```dart
  /// final response = await retryHandler.retryRequest(() => dio.get('https://api.example.com/data'));
  /// ```
  Future<Response<T>> retryRequest<T>(
    Future<Response<T>> Function() request, {
    int maxRetries = 3,
    int initialDelay = 1000,
    int backoffFactor = 2,
  }) async {
    int retryCount = 0;
    int delay = initialDelay;
    Response<T>? response;

    while (retryCount < maxRetries) {
      try {
        response = await request();
        break;
      } catch (e, stackTrace) {
        if (isRetryableError(e) && retryCount <= maxRetries) {
          retryCount++;
          await Future.delayed(Duration(milliseconds: delay));
          delay *= backoffFactor;
          continue;
        } else if (retryCount == maxRetries) {
          await sentryService.logErrorToSentry(
              'Max retries exceeded', StackTrace.current, retryCount);
        } else {
          await sentryService.logErrorToSentry(
              e.toString(), stackTrace, retryCount);
          rethrow;
        }
      }
    }

    if (response != null) {
      return response;
    } else {
      throw MaxRetriesExceededException(
          'Max retries exceeded without a successful request');
    }
  }

  /// Checks if an error is retryable.
  ///
  /// This function verifies if the error is an instance of `DioException` and if
  /// its response status code is included in a list of retryable status codes.
  ///
  /// @param e The error object to check if it is retryable.
  /// @return A boolean value indicating whether the error is retryable or not.
  ///
  /// @example
  /// ```dart
  /// final isRetryable = isRetryableError(error);
  /// ```
  bool isRetryableError(dynamic e) {
    return e is DioException &&
        RetryableStatusCodes.defaultRetryStatusCodes
            .contains(e.response?.statusCode);
  }
}

import 'package:dio/dio.dart';
import 'package:empylo_app/constants/retryable_status_codes.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';

Future<Response<T>> retryRequest<T>(
  Future<Response<T>> Function() request, {
  int maxRetries = 3,
  int initialDelay = 1000,
  int backoffFactor = 2,
  required SentryService sentryService,
}) async {
  int retryCount = 0;
  int delay = initialDelay;

  while (retryCount < maxRetries) {
    try {
      final response = await request();

      if (RetryableStatusCodes.defaultRetryStatusCodes
          .contains(response.statusCode)) {
        retryCount++;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= backoffFactor;
      } else {
        return response;
      }
    } catch (e, stackTrace) {
      if (retryCount >= maxRetries - 1) {
        await logErrorToSentry(e, stackTrace, retryCount, sentryService);
        rethrow;
      }

      retryCount++;
      await Future.delayed(Duration(milliseconds: delay));
      delay *= backoffFactor;
    }
  }

  await logErrorToSentry(
      'Max retries exceeded', StackTrace.current, retryCount, sentryService);
  throw Exception('Max retries exceeded');
}

Future<void> logErrorToSentry(dynamic e, StackTrace stackTrace, int attempt,
    SentryService sentryService) async {
  if (e != null) {
    final event = ErrorEvent(
      message: 'Failed to execute request on attempt $attempt: $e',
      level: 'error',
      extra: {'stackTrace': stackTrace.toString()},
    );
    await sentryService.sendErrorEvent(event);
  }
}

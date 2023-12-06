import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:empylo_app/constants/retryable_status_codes.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';

Future<T> retryRequest<T>(
  Future<T> Function() request, {
  int maxRetries = 3,
  int initialDelay = 1000,
  int backoffFactor = 2,
  required SentryService sentryService,
}) async {
  if (maxRetries < 1 || initialDelay < 0 || backoffFactor < 1) {
    throw ArgumentError('Invalid parameters');
  }

  int retries = 0;
  int delay = initialDelay;
  String lastError = '';

  while (retries < maxRetries) {
    try {
      final response = await request();
      if (response is Response) {
        if (RetryableStatusCodes.defaultRetryStatusCodes
            .contains(response.statusCode)) {
          lastError = 'Response with retryable status code: ${response.data}';
          retries++;
          if (retries == maxRetries) {
            break;
          }
          await Future.delayed(Duration(milliseconds: delay));
          delay *= backoffFactor;
        } else {
          if (response.data is String) {
            return jsonDecode(response.data);
          } else {
            return response.data as T;
          }
        }
      } else {
        throw Exception('Response is not a Response object');
      }
    } catch (e, stackTrace) {
      if (e is DioException && shouldRetry(e)) {
        lastError =
            'DioException with retryable status: ${e.response?.data ?? 'No response data'}';
        retries++;
        if (retries == maxRetries) {
          break;
        }
        await Future.delayed(Duration(milliseconds: delay));
        delay *= backoffFactor;
      } else {
        logErrorToSentry(e, stackTrace, retries, sentryService);
        rethrow;
      }
    }
  }

  logErrorToSentry(lastError, StackTrace.current, retries, sentryService);
  throw Exception('Maximum retry attempts reached. Last error: $lastError');
}

bool shouldRetry(DioException? e) {
  if (e == null) {
    return false;
  }
  return e.response?.statusCode != null &&
      RetryableStatusCodes.defaultRetryStatusCodes
          .contains(e.response!.statusCode);
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

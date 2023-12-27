/*
This file defines the sentry service for reporting errors to sentry. It uses the
dio package to make the requests, flutter_riverpod 2.0 to manage state.
*/

// Path: lib/services/sentry.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';

/// An abstract class for sending error events to Sentry.
/// This class is used to send error events to Sentry.
/// It is implemented using the [Dio] package.
///   - [dio] is the [Dio] instance used to make the requests.
///   - [sentryKey] is the Sentry key used to authenticate the requests.
///   - [projectId] is the Sentry project ID used to authenticate the requests.
class SentryService {
  final Dio _dio;
  final String _sentryKey;
  final String _projectId;

  SentryService({dio, sentryKey, projectId})
      : _dio = dio,
        _sentryKey = sentryKey,
        _projectId = projectId;

  /// Sends an error event to Sentry.
  ///   - [event] is the [ErrorEvent] to send.
  Future<void> sendErrorEvent(ErrorEvent event) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'X-Sentry-Auth':
            'Sentry sentry_version=7, sentry_key=$_sentryKey, sentry_client=dio/0.1',
      };
      final json = event.toJson();
      final response = await _dio.post(
        'https://sentry.io/api/$_projectId/store/',
        data: json,
        options: Options(headers: headers),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw SentryError('Error: ${response.statusCode}', StackTrace.current,
            response.statusCode ?? 500);
      }
    } catch (e) {
      // In case of failure, handle it gracefully without rethrowing.
      // Log it to console/device logs (or another service if available).
      print('Failed to send error log to Sentry: ${e.toString()}');
    }
  }

  /// Logs an error to Sentry.
  /// - [e] is the error to log.
  /// - [stackTrace] is the stack trace of the error.
  /// - [attempt] is the attempt number of the request.
  /// - [level] is the level of the error.
  Future<void> logErrorToSentry(
    dynamic e,
    StackTrace stackTrace, [
    int? attempt,
    String? level,
  ]) async {
    if (e != null) {
      final event = ErrorEvent(
        message: attempt != null
            ? 'Attempt $attempt: ${e.toString()}'
            : e.toString(),
        level: level ?? 'error',
        extra: {'stackTrace': stackTrace.toString()},
      );
      await sendErrorEvent(event);
    }
  }
}

/*
This file defines the sentry service for reporting errors to sentry. It uses the
dio package to make the requests, flutter_riverpod 2.0 to manage state.
*/

// Path: lib/services/sentry.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';

class SentryService {
  final Dio _dio;
  final String _sentryKey;
  final String _projectId;

  SentryService({dio, sentryKey, projectId})
      : _dio = dio,
        _sentryKey = sentryKey,
        _projectId = projectId;

  Future<Response> sendErrorEvent(ErrorEvent event) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'X-Sentry-Auth':
            'Sentry sentry_version=7, sentry_key=$_sentryKey, sentry_client=dio/0.1',
      };
      final json = event.toJson();
      return await _dio.post(
        'https://sentry.io/api/$_projectId/store/',
        data: json,
        options: Options(headers: headers),
      );
    } catch (e) {
      return Response(
        statusCode: 500,
        requestOptions: RequestOptions(
            path: 'https://sentry.io/api/$_projectId/store/', data: e),
      );
    }
  }
}

void main() async {
  const String sentryKey = '3c590eaf5e55481ab572190cf4119b65';
  const String projectId = '6751717';
  final sentry = SentryService(
    dio: Dio(),
    sentryKey: sentryKey,
    projectId: projectId,
  );
  final event = ErrorEvent(
    message: 'This is a test message',
    level: 'error',
    extra: {'context': 'dart test'},
  );
  await sentry.sendErrorEvent(event);
}

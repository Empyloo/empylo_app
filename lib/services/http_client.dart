/*
An example of an endpoint is:
```
select
curl 'https://banckend.com/rest/v1/users?select=id' \
-H "apikey: KEY" \
-H "Authorization: Bearer KEY"
```
*/
// Path: lib/services/http_client.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/models/user_data.dart';
import 'package:empylo_app/services/sentry.dart';

class HttpClient {
  final Dio _dio;
  final SentryService _sentry;

  HttpClient({
    dio,
    sentry,
    baseUrl,
    anonKey,
    headers,
  })  : _dio = dio,
        _sentry = sentry;

  Future<Response> post({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    int retries = 0;
    int delay = initialDelay;
    while (retries < maxRetries) {
      try {
        return await _dio.post(
          url,
          data: data,
          options: Options(headers: headers),
        );
      } on DioError catch (e) {
        if (e.response != null) {
          await _sentry.sendErrorEvent(ErrorEvent(
            message: e.toString(),
            level: 'error',
            extra: {'context': e.response!.data},
          ));
        } else {
          await _sentry.sendErrorEvent(ErrorEvent(
            message: e.toString(),
            level: 'error',
            extra: {'context': 'retry'},
          ));
        }
        retries++;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= 2;
      }
    }
    return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 500,
        statusMessage:
            'Error: Could not connect to server. Retried $retries times.');
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    int retries = 0;
    int delay = initialDelay;
    while (retries < maxRetries) {
      try {
        return await _dio.get(
          url,
          options: Options(headers: headers),
          queryParameters: queryParameters,
        );
      } on DioError catch (e) {
        if (e.response != null) {
          await _sentry.sendErrorEvent(ErrorEvent(
            message: e.toString(),
            level: 'error',
            extra: {'context': e.response!.data},
          ));
        } else {
          await _sentry.sendErrorEvent(ErrorEvent(
            message: e.toString(),
            level: 'error',
            extra: {'context': 'retry'},
          ));
        }
        retries++;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= 2;
      }
    }
    return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 500,
        statusMessage:
            'Error: Could not connect to server. Retried $retries times.');
  }

  Future<Response> update({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    int retries = 0;
    int delay = initialDelay;
    while (retries < maxRetries) {
      try {
        return await _dio.put(
          url,
          data: data,
          options: Options(headers: headers),
        );
      } on DioError catch (e) {
        if (e.response != null) {
          await _sentry.sendErrorEvent(ErrorEvent(
            message: e.toString(),
            level: 'error',
            extra: {'context': e.response!.data},
          ));
        } else {
          await _sentry.sendErrorEvent(ErrorEvent(
            message: e.toString(),
            level: 'error',
            extra: {'context': 'retry'},
          ));
        }
        retries++;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= 2;
      }
    }
    return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 500,
        statusMessage:
            'Error: Could not connect to server. Retried $retries times.');
  }

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? headers,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    int retries = 0;
    int delay = initialDelay;
    while (retries < maxRetries) {
      try {
        return await _dio.delete(
          url,
          options: Options(headers: headers),
        );
      } on DioError catch (e) {
        if (e.response != null) {
          await _sentry.sendErrorEvent(ErrorEvent(
            message: e.toString(),
            level: 'error',
            extra: {'context': e.response!.data},
          ));
        } else {
          await _sentry.sendErrorEvent(ErrorEvent(
            message: e.toString(),
            level: 'error',
            extra: {'context': 'retry'},
          ));
        }
        retries++;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= 2;
      }
    }
    return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 500,
        statusMessage:
            'Error: Could not connect to server. Retried $retries times.');
  }
}

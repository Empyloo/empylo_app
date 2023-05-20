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
import 'package:empylo_app/services/sentry_service.dart';

enum HttpMethod { GET, POST, PUT, DELETE, PATCH }

class HttpClient {
  final Dio _dio;
  final SentryService _sentry;

  static const int _backoffFactor = 2;

  HttpClient({
    required Dio dio,
    required SentryService sentry,
  })  : _dio = dio,
        _sentry = sentry;

  Future<Response> post({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    return _retryOnError(
      () => _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      ),
      HttpMethod.POST,
      maxRetries: maxRetries,
      initialDelay: initialDelay,
    );
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? headers,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    return _retryOnError(
      () => _dio.get(
        url,
        options: Options(headers: headers),
      ),
      HttpMethod.GET,
      maxRetries: maxRetries,
      initialDelay: initialDelay,
    );
  }

  Future<Response> patch({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    return _retryOnError(
      () => _dio.patch(
        url,
        data: data,
        options: Options(headers: headers),
      ),
      HttpMethod.PATCH,
      maxRetries: maxRetries,
      initialDelay: initialDelay,
    );
  }

  Future<Response> put({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    return _retryOnError(
      () => _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      ),
      HttpMethod.PUT,
      maxRetries: maxRetries,
      initialDelay: initialDelay,
    );
  }

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? headers,
    int maxRetries = 3,
    int initialDelay = 1000,
  }) async {
    return _retryOnError(
      () => _dio.delete(
        url,
        options: Options(headers: headers),
      ),
      HttpMethod.DELETE,
      maxRetries: maxRetries,
      initialDelay: initialDelay,
    );
  }

  Future<T> _retryOnError<T>(Future<T> Function() request, HttpMethod method,
      {int maxRetries = 3, int initialDelay = 1000}) async {
    int retries = 0;
    int delay = initialDelay;
    while (retries < maxRetries) {
      try {
        return await request();
      } on DioError catch (e) {
        bool shouldRetry = await _handleError(e, method);

        if (!shouldRetry) {
          rethrow;
        }

        retries++;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= _backoffFactor;

        if (retries == maxRetries) {
          rethrow;
        }
      }
    }
    throw Exception('Could not connect to server.');
  }

  Future<bool> _handleError(DioError e, HttpMethod method) async {
    await _sentry.sendErrorEvent(
      ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'method': method, 'context': e.response?.data},
      ),
    );

    if (e.response != null &&
        e.response!.data is Map<String, dynamic> &&
        (e.response!.data as Map<String, dynamic>)['error'] ==
            'invalid_grant') {
      return false;
    } else if (e.response!.statusCode == 400) {
      return false;
    } else if (e.response!.statusCode == 401) {
      return false;
    } else if (e.response!.statusCode == 403) {
      return false;
    } else if (e.response!.statusCode == 404) {
      return false;
    } else {
      return true;
    }
  }
}

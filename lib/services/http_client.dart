/*
An example of an endpoint is:
```
select
curl 'https://backend.com/rest/v1/users?select=id' \
-H "apikey: KEY" \
-H "Authorization: Bearer KEY"
```
*/
// Path: lib/services/http_client.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/services/retry_handler.dart';

class HttpClient {
  final Dio _dio;
  final RetryHandler _retryHandler;

  HttpClient({
    required Dio dio,
    required RetryHandler retryHandler,
  })  : _dio = dio,
        _retryHandler = retryHandler;

  Future<Response> post({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    return _retryHandler.execute(
      () => _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? headers,
  }) async {
    return _retryHandler.execute(
      () => _dio.get(
        url,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Response> put({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    return _retryHandler.execute(
      () => _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? headers,
  }) async {
    return _retryHandler.execute(
      () => _dio.delete(
        url,
        options: Options(headers: headers),
      ),
    );
  }

  Future<Response> patch({
    required String url,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    return _retryHandler.execute(
      () => _dio.patch(
        url,
        data: data,
        options: Options(headers: headers),
      ),
    );
  }
}


void main() async {
  final dio = Dio();
  final retryHandler = RetryHandler();
  final httpClient = HttpClient(
    dio: dio,
    retryHandler: retryHandler,
  );

  final response = await httpClient.get(
    url: '$remoteBaseUrl/rest/v1/companies',
    headers: {
      'apikey': remoteAnonKey,
      'Authorization': 'Bearer $remoteAnonKey',
    },
  );

  print(response.data);
}

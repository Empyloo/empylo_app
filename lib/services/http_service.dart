// services/http_service.dart
import 'package:dio/dio.dart';

/// An abstract class for making HTTP requests.
abstract class HttpService {
  Future<Response> post(String url,
      {Map<String, dynamic>? headers, dynamic data});
  Future<Response> get(String url, {Map<String, dynamic>? headers});
  Future<Response> put(String url,
      {Map<String, dynamic>? headers, dynamic data});
  Future<Response> delete(String url, {Map<String, dynamic>? headers});
  Future<Response> patch(String url,
      {Map<String, dynamic>? headers, dynamic data});
}

/// A concrete implementation of [HttpService] using [Dio].
class DioHttpService implements HttpService {
  final Dio _dio;

  DioHttpService(this._dio);

  /// Makes a POST request to the given [url] with the given [headers] and
  /// [data].
  @override
  Future<Response> post(String url,
      {Map<String, dynamic>? headers, dynamic data}) {
    return _dio.post(url, data: data, options: Options(headers: headers));
  }

  /// Makes a GET request to the given [url] with the given [headers].
  @override
  Future<Response> get(String url, {Map<String, dynamic>? headers}) {
    return _dio.get(url, options: Options(headers: headers));
  }

  /// Makes a PUT request to the given [url] with the given [headers] and
  @override
  Future<Response> put(String url,
      {Map<String, dynamic>? headers, dynamic data}) {
    return _dio.put(url, data: data, options: Options(headers: headers));
  }

  /// Makes a DELETE request to the given [url] with the given [headers].
  @override
  Future<Response> delete(String url, {Map<String, dynamic>? headers}) {
    return _dio.delete(url, options: Options(headers: headers));
  }

  /// Makes a PATCH request to the given [url] with the given [headers] and
  @override
  Future<Response> patch(String url,
      {Map<String, dynamic>? headers, dynamic data}) {
    return _dio.patch(url, data: data, options: Options(headers: headers));
  }
}

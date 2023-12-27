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
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_service.dart';
import 'package:empylo_app/services/retry_handler.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/utils/dio_http_exception.dart';

/// HttpClient class using HttpService and ErrorService interfaces.
class HttpClient {
  final HttpService _httpService;
  final SentryService _sentryService;
  final RetryHandler _retryHandler;

  HttpClient({
    required HttpService httpService,
    required SentryService sentryService,
    required RetryHandler retryHandler,
  })  : _httpService = httpService,
        _sentryService = sentryService,
        _retryHandler = retryHandler;

  /// Executes a request with retries and error handling.
  ///
  /// If a DioException is thrown, it handles the exception based on its type.
  /// If an unknown exception is thrown, it logs the error using the ErrorService.
  ///
  /// @param request A function that returns a Future<Response>. This function is called to make the request.
  /// @param retryParams A map of parameters that can contain the maxRetries, initialDelay, and backoffFactor parameters.
  /// @returns A Future<Response> that completes with the response from the request.
  /// @throws DioHttpException if an error occurs while processing the request.
  Future<Response> executeRequest(
    Future<Response> Function() request, {
    Map<String, dynamic>? retryParams,
  }) async {
    try {
      return await _retryHandler.retryRequest(
        request,
        maxRetries: retryParams?['maxRetries'] ?? 3,
        initialDelay: retryParams?['initialDelay'] ?? 1000,
        backoffFactor: retryParams?['backoffFactor'] ?? 2,
      );
    } on DioException catch (e) {
      // Handle the DioError here
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        final message = e.message ??
            'An error occurred while processing your request. Please try again later.';
        throw DioHttpException(message, e.response?.statusCode);
      } else if (e.type == DioExceptionType.badResponse) {
        final message =
            e.message ?? 'An error occurred while processing your request.';
        throw DioHttpException(message, e.response?.statusCode);
      } else {
        final message = e.message ??
            'An error occurred while processing your request. It is not retryable.';
        throw DioHttpException(message, e.response?.statusCode);
      }
    } catch (e) {
      print('££ Unknown error: ${e.toString()}');
      await _sentryService.sendErrorEvent(
        ErrorEvent(
          message: e.toString(),
          level: 'error',
          extra: {'stackTrace': e.toString()},
        ),
      );
      //
      // Handle the unknown error here
      throw DioHttpException(e.toString());
    } finally {
      // Clean up resources
    }
  }

  /// Executes a POST request.
  ///
  /// This method executes a POST request and handles retries based on the parameters provided.
  /// If a DioException is thrown, it handles the exception based on its type.
  /// If an unknown exception is thrown, it logs the error using the ErrorService.
  ///
  /// @param url The URL to make the request to.
  /// @param headers The headers to include in the request.
  /// @param data The data to include in the request.
  /// @param retryParams A map of parameters that can contain the maxRetries, initialDelay, and backoffFactor parameters.
  /// @returns A Future<Response> that completes with the response from the request.
  Future<Response> post({
    required String url,
    required Map<String, dynamic> headers,
    dynamic data,
    Map<String, dynamic>? retryParams,
  }) async {
    return executeRequest(
      () => _httpService.post(
        url,
        headers: headers,
        data: data,
      ),
      retryParams: retryParams,
    );
  }

  /// Executes a GET request.
  ///
  /// This method executes a GET request and handles retries based on the parameters provided.
  /// If a DioException is thrown, it handles the exception based on its type.
  /// If an unknown exception is thrown, it logs the error using the ErrorService.
  ///
  /// @param url The URL to make the request to.
  /// @param headers The headers to include in the request.
  /// @param retryParams A map of parameters that can contain the maxRetries, initialDelay, and backoffFactor parameters.
  /// @returns A Future<Response> that completes with the response from the request.
  Future<Response> get({
    required String url,
    required Map<String, dynamic> headers,
    Map<String, dynamic>? retryParams,
  }) async {
    return executeRequest(
      () => _httpService.get(
        url,
        headers: headers,
      ),
      retryParams: retryParams,
    );
  }

  /// Supabase has no PUT request.

  /// Executes a PATCH request.
  ///
  /// Use when sending a partial update to an existing resource.
  /// @param url The URL to make the request to.
  /// @param headers The headers to include in the request.
  /// @param data The data to include in the request.
  /// @param params A map of parameters for retry logic.
  /// @returns A Future<Response> that completes with the response from the request.
  Future<Response> patch({
    required String url,
    required Map<String, dynamic> headers,
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return executeRequest(
      () => _httpService.patch(
        url,
        headers: headers,
        data: data,
      ),
      retryParams: params,
    );
  }

  /// Executes a DELETE request.
  /// This method executes a DELETE request and handles retries based on the
  /// parameters provided.
  /// @param url The URL to make the request to.
  /// @param headers The headers to include in the request.
  /// @param retryParams A map of parameters that can contain the maxRetries, initialDelay, and backoffFactor parameters.
  /// @returns A Future<Response> that completes with the response from the request.
  Future<Response> delete({
    required String url,
    required Map<String, dynamic> headers,
    Map<String, dynamic>? retryParams,
  }) async {
    return executeRequest(
      () => _httpService.delete(
        url,
        headers: headers,
      ),
      retryParams: retryParams,
    );
  }
}

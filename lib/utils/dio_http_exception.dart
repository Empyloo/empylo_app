/// Represents an exception that occurs during HTTP requests using Dio.
class DioHttpException implements Exception {
  final String message;
  final int? statusCode;

  /// Creates a new instance of [DioHttpException].
  ///
  /// The [message] parameter represents the error message associated with the exception.
  /// The [statusCode] parameter represents the HTTP status code associated with the exception.
  DioHttpException(this.message, [this.statusCode]);

  @override
  String toString() {
    return 'DioHttpException: $message, status code: $statusCode';
  }
}

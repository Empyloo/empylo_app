class MaxRetriesExceededException implements Exception {
  final String message;

  MaxRetriesExceededException(this.message);

  @override
  String toString() => 'MaxRetriesExceededException: $message';
}

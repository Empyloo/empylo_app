// Path: lib/constants/retryable_status_codes.dart

/// Provides a list of HTTP status codes that should trigger a retry when
/// encountered.
class RetryableStatusCodes {
  static final List<int> defaultRetryStatusCodes = [
    408,
    429,
    500,
    502,
    503,
    504,
    440,
    460,
    499,
    520,
    521,
    522,
    523,
    524,
    525,
    527,
    598,
    599
  ];
}

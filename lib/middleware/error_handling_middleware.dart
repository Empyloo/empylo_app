// Path: lib/middleware/error_handling_middleware.dart
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry/sentry_service.dart';

class ErrorHandlingMiddleware {
  final SentryService _sentry;

  ErrorHandlingMiddleware({required SentryService sentry}) : _sentry = sentry;

  Future<T> handleErrors<T>(
      Future<T> Function() operation, String context) async {
    try {
      return await operation();
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error in $context',
          level: 'error',
          extra: {'error': e},
        ),
      );
      rethrow;
    }
  }
}

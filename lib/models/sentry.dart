// Sentry Model
class SentryEvent {
  final String eventId;
  final String transaction;
  final DateTime timestamp;
  final Map<String, String> tags;
  final Map<String, dynamic> exception;

  SentryEvent(
      {required this.eventId,
      required this.transaction,
      required this.timestamp,
      required this.tags,
      required this.exception});

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'transaction': transaction,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
      'exception': exception,
    };
  }
}

class ErrorEvent {
  final String message;
  final String level;
  final Map<String, dynamic> extra;

  ErrorEvent({
    required this.message,
    required this.level,
    required this.extra,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'level': level,
        'extra': extra,
      };
}

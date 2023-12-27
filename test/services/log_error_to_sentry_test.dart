// Path: test/sentry_test.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

class MockSentryService extends Mock implements SentryService {
  @override
  Future<void> sendErrorEvent(ErrorEvent event) {
    return super.noSuchMethod(
      Invocation.method(#sendErrorEvent, [event]),
    );
  }
}

class StackTraceFake extends Fake implements StackTrace {}

final errorEvent = ErrorEvent(
  message: 'This is a test message',
  level: 'error',
  extra: {'context': 'dart test'},
);

void main() {
  late MockDio dio;
  late SentryService sentry;
  var id = 'project-id';
  var sentryKey = 'sentry-key';

  setUp(() {
    dio = MockDio();
    sentry = SentryService(
      dio: dio,
      sentryKey: sentryKey,
      projectId: id,
    );
  });

  group('test SentryService.logErrorToSentry', () {
    test('should send error event with expected params', () async {
      // arrange
      final error = Exception('Test error');
      final stackTrace = StackTraceFake();
      final expectedEvent = ErrorEvent(
        message: error.toString(),
        level: 'error',
        extra: {'stackTrace': stackTrace.toString()},
      );

      when(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: expectedEvent.toJson(),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(
              path: 'https://sentry.io/api/project-id/store/',
            ),
          ));

      // act
      await sentry.logErrorToSentry(error, stackTrace);

      // assert
      verify(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: expectedEvent.toJson(),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    // sendErrorEvent handles exceptions gracefully and doesn't propagate them to logErrorToSentry.
    test('should not throw an exception', () async {
      // arrange
      final error = Exception('Test error');
      final stackTrace = StackTraceFake();

      when(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('Test exception'));

      // act
      await sentry.logErrorToSentry(error, stackTrace);

      // assert
      verify(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should not send error event when error is null', () async {
      // arrange
      final error = null;
      final stackTrace = StackTraceFake();

      // act
      await sentry.logErrorToSentry(error, stackTrace);

      // assert
      verifyNever(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      );
    });

    // test attempt number is included in the error message if provided.
    test('should include attempt number in error message', () async {
      // arrange
      final error = Exception('Test error');
      final stackTrace = StackTraceFake();
      final expectedEvent = ErrorEvent(
        message: 'Attempt 1: ${error.toString()}',
        level: 'error',
        extra: {'stackTrace': stackTrace.toString()},
      );

      when(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: expectedEvent.toJson(),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(
              path: 'https://sentry.io/api/project-id/store/',
            ),
          ));

      // act
      await sentry.logErrorToSentry(error, stackTrace, 1);

      // assert
      verify(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: expectedEvent.toJson(),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    // test level is included in the error message if provided.
    test('should include level in error message', () async {
      // arrange
      final error = Exception('Test error');
      final stackTrace = StackTraceFake();
      final expectedEvent = ErrorEvent(
        message: error.toString(),
        level: 'warning',
        extra: {'stackTrace': stackTrace.toString()},
      );

      when(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: expectedEvent.toJson(),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(
              path: 'https://sentry.io/api/project-id/store/',
            ),
          ));

      // act
      await sentry.logErrorToSentry(error, stackTrace, null, 'warning');

      // assert
      verify(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: expectedEvent.toJson(),
          options: any(named: 'options'),
        ),
      ).called(1);
    });
  });
}

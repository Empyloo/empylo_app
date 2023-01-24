// Path: test/sentry_test.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

final event = ErrorEvent(
  message: 'This is a test message',
  level: 'error',
  extra: {'context': 'dart test'},
);

void main() {
  late MockDio dio;
  const String sentryKey = 'key';
  const String projectId = 'project-id';

  setUp(() {
    dio = MockDio();
  });

  group('SentryService', () {
    test('should send error event', () async {
      // arrange
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(
              path: 'https://sentry.io/api/project-id/store/',
            ),
          ));

      final sentry = SentryService(
        dio: dio,
        sentryKey: sentryKey,
        projectId: projectId,
      );

      // act
      final response = await sentry.sendErrorEvent(event);

      // assert
      expect(response.statusCode, 200);
      expect(response.requestOptions.path,
          'https://sentry.io/api/project-id/store/');
    });

    test('should return error response', () async {
      // arrange
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception('error'));

      final sentry = SentryService(
        dio: dio,
        sentryKey: sentryKey,
        projectId: projectId,
      );

      // act
      final response = await sentry.sendErrorEvent(event);

      // assert
      expect(response.statusCode, 500);
      expect(response.requestOptions.path,
          'https://sentry.io/api/project-id/store/');
      expect(response.requestOptions.data, isA<Exception>());
    });
  });
}

// To run the test, run the following command:
// $ flutter test test/sentry_test.dart
// Path: test/sentry_test.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';
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
  late SentryService sentry;

  setUp(() {
    dio = MockDio();
    sentry = SentryService(
      dio: dio,
      sentryKey: sentryKey,
      projectId: projectId,
    );
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

      // act
      await sentry.sendErrorEvent(event);

      // assert
      verify(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: event.toJson(),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test(
      'sendErrorEvent throws SentryError when Sentry API returns an error response',
      () async {
        when(() => dio.post(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: 'https://sentry.io/api/project-id/store/',
            ),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(
                path: 'https://sentry.io/api/project-id/store/',
              ),
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        await expectLater(
          () => sentry.sendErrorEvent(event),
          throwsA(isA<SentryError>()),
        );

        // Act and Assert
        verify(
          () => dio.post(
            'https://sentry.io/api/project-id/store/',
            data: event.toJson(),
            options: any(named: 'options'),
          ),
        ).called(1);
      },
    );
  });

  test("Test non-dio error/excpetion", () async {
    when(() => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        )).thenThrow(
      Exception("Test Exception"),
    );

    await expectLater(
      () => sentry.sendErrorEvent(event),
      throwsA(isA<SentryError>()),
    );

    // Act and Assert
    verify(
      () => dio.post(
        'https://sentry.io/api/project-id/store/',
        data: event.toJson(),
        options: any(named: 'options'),
      ),
    ).called(1);
  });

  test(
    'sendErrorEvent throws SentryError when Sentry API returns a non-200 status code',
    () async {
      when(() => dio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            statusCode: 202,
            requestOptions: RequestOptions(
              path: 'https://sentry.io/api/project-id/store/',
            ),
          ));

      await expectLater(
        () => sentry.sendErrorEvent(event),
        throwsA(isA<SentryError>()),
      );

      // Act and Assert
      verify(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: event.toJson(),
          options: any(named: 'options'),
        ),
      ).called(1);
    },
  );
}
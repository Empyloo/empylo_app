import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

class MockSentryService extends Mock implements SentryService {}

class StackTraceFake extends Fake implements StackTrace {}

final errorEvent = ErrorEvent(
  message: 'This is a test message',
  level: 'error',
  extra: {'context': 'dart test'},
);

class FakeErrorEvent extends Fake implements ErrorEvent {}

void main() {
  late MockDio dio;
  const String sentryKey = 'key';
  const String projectId = 'project-id';
  late SentryService sentry;

  setUpAll(() {
    registerFallbackValue(errorEvent);
    registerFallbackValue(StackTraceFake());
    registerFallbackValue(FakeErrorEvent());
  });
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
      await sentry.sendErrorEvent(errorEvent);

      // assert
      verify(
        () => dio.post(
          'https://sentry.io/api/project-id/store/',
          data: errorEvent.toJson(),
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
          () => sentry.sendErrorEvent(errorEvent),
          throwsA(isA<SentryError>()),
        );

        // Act and Assert
        verify(
          () => dio.post(
            'https://sentry.io/api/project-id/store/',
            data: errorEvent.toJson(),
            options: any(named: 'options'),
          ),
        ).called(1);
      },
    );
  });
}

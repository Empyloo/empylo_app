import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/retry_handler.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empylo_app/services/http_service.dart';
import 'package:empylo_app/services/http_client.dart';

class MockDio extends Mock implements Dio {}

class MockSentryService extends Mock implements SentryService {}

void main() {
  late HttpService httpService;
  late HttpClient httpClient;
  late SentryService sentry;

  setUp(() {
    httpService = DioHttpService(MockDio());
    httpClient = HttpClient(
      httpService: httpService,
      sentryService: MockSentryService(),
      retryHandler: RetryHandler(
        sentryService: MockSentryService(),
      ),
    );
  });

  setUpAll(() {
    const error = 'Test error';
    final stackTrace = StackTrace.current;
    const attempt = 1;
    registerFallbackValue(ErrorEvent(
      message: 'Failed to execute request on attempt $attempt: $error',
      level: 'error',
      extra: {'stackTrace': stackTrace.toString()},
    ));
  });

  test('test executeRequest executes request and returns response', () async {
    // Create a mock Dio instance
    var dio = MockDio();

    // Set up the mock Dio instance to return a predefined response
    when(
      () => dio.get(
        any(),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
      ),
    );

    httpClient = HttpClient(
      httpService: DioHttpService(dio),
      sentryService: MockSentryService(),
      retryHandler: RetryHandler(
        sentryService: MockSentryService(),
      ),
    );

    var response = await httpClient
        .executeRequest(() => dio.get('url', options: Options()));

    // Assert that the response has the expected status code
    expect(response.statusCode, equals(200));
  });

  test('test executeRequest handles retry logic correctly', () async {
    // Create a mock Dio instance
    var dio = MockDio();
    var sentry = MockSentryService();

    // Set up the mock Dio instance to return a predefined response
    when(
      () => dio.get(
        any(),
        options: any(named: 'options'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
        ),
      ),
    );

    when(
      () => sentry.sendErrorEvent(
        any(),
      ),
    ).thenAnswer((invocation) => Future.value());

    httpClient = HttpClient(
      httpService: DioHttpService(dio),
      sentryService: MockSentryService(),
      retryHandler: RetryHandler(
        sentryService: MockSentryService(),
      ),
    );

    var response = await httpClient.executeRequest(
      () => dio.get('url', options: Options()),
      retryParams: {
        'maxRetries': 3,
        'initialDelay': 1000,
        'backoffFactor': 2,
      },
    );

    // Assert that the response has the expected status code
    expect(response.statusCode, equals(500));

    verify(
      () => dio.get(
        any(),
        options: any(named: 'options'),
      ),
    ).called(4);
  });
}

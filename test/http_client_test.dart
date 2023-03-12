// Path: test/http_client_test.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

class MockSentryDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late MockSentryDio sentryDio;
  late SentryService sentry;
  late HttpClient client;

  setUp(() {
    dio = MockDio();
    sentryDio = MockSentryDio();
    sentry = SentryService(
      dio: sentryDio,
      sentryKey: 'key',
      projectId: 'project-id',
    );
    client = HttpClient(
      dio: dio,
      sentry: sentry,
    );
  });

  group('HttpClient Post', () {
    test('should return response', () async {
      // arrange
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 200,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.post(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 200);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
    });

    test('should return error response', () async {
      // arrange
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 400,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.post(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 400);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
    });

    test('should handle error', () async {
      // arrange
      when(
        () => dio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioError(
          requestOptions: RequestOptions(
            path: 'https://banckend.com/rest/v1/users?select=id',
          ),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.post(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 500);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');

      verify(
        () => sentryDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(3);
    });
  });

  group('HttpClient Get', () {
    test('should return response', () async {
      // arrange
      when(
        () => dio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 200,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.get(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 200);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
    });

    test('should return error response', () async {
      // arrange
      when(
        () => dio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 400,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.get(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 400);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
    });

    test('should handle error', () async {
      // arrange
      when(
        () => dio.get(
          any(),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioError(
          requestOptions: RequestOptions(
            path: 'https://banckend.com/rest/v1/users?select=id',
          ),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.get(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 500);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');

      verify(
        () => sentryDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(3);
    });
  });

  group('HttpClient Update', () {
    test('should return response', () async {
      // arrange
      when(
        () => dio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 200,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.update(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 200);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
    });

    test('should return error response', () async {
      // arrange
      when(
        () => dio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 400,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.update(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 400);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
    });

    test('should handle error', () async {
      // arrange
      when(
        () => dio.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioError(
          requestOptions: RequestOptions(
            path: 'https://banckend.com/rest/v1/users?select=id',
          ),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.update(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 500);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
        
      verify(
        () => sentryDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(3);
    });
  });

  group('HttpClient Delete', () {
    test('should return response', () async {
      // arrange
      when(
        () => dio.delete(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 200,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.delete(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 200);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
    });

    test('should return error response', () async {
      // arrange
      when(
        () => dio.delete(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Future.value(
          Response(
            statusCode: 400,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.delete(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 400);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');
    });

    test('should handle error', () async {
      // arrange
      when(
        () => dio.delete(
          any(),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioError(
          requestOptions: RequestOptions(
            path: 'https://banckend.com/rest/v1/users?select=id',
          ),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(
                path: 'https://banckend.com/rest/v1/users?select=id'),
          ),
        ),
      );

      // act
      final response = await client.delete(
        url: 'https://banckend.com/rest/v1/users?select=id',
      );

      // assert
      expect(response.statusCode, 500);
      expect(response.requestOptions.path,
          'https://banckend.com/rest/v1/users?select=id');

      verify(
        () => sentryDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(3);
    });
  });
}

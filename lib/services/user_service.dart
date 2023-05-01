/*
User Service to make networks calls for user related
operations. This includes invites, login, logout,
profile update, password reset, etc.
*/
// Path: lib/services/user_service.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/models/session.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/models/user_data.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';

class UserService {
  final HttpClient _httpClient;
  final SentryService _sentry;

  UserService({
    httpClient,
    sentry,
  })  : _httpClient = httpClient,
        _sentry = sentry;

  /// For inviting user/s to the organization, an admin user
  /// will add an email, emails or upload a csv file with
  /// the email addresses of the invitees.
  /// If only one email is provided, it will be put in a list
  /// of one email.
  /// The `invites` service method should expect a list of
  ///  `Invite` strings (emails).
  /// The acceess token of the user sending invites is added
  /// headers. organizationId and organizationName are optional.
  Future<Response> invites({
    required List<String> emails,
    String? organizationId,
    String? organizationName,
    String? role,
    String? accessToken,
  }) async {
    try {
      return await _httpClient.post(
        url: 'https://app.empylo.com/api/v1/invite-users',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        data: {
          'emails': emails,
          'organizationId': organizationId,
          'organizationName': organizationName,
          'role': role,
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'invites'},
      ));
      return Response(
          requestOptions: RequestOptions(path: '/invites'),
          statusCode: 500,
          statusMessage: 'Error: Could not connect to server.');
    }
  }

  /// For logging in, the user will provide an email and
  /// password. The `login` service method should expect
  /// a `User` object.
  /// The anonKey token of the user sending invites is added
  /// headers.
  Future<Session> login({
    required String email,
    required String password,
    required String baseUrl,
    required String anonKey,
  }) async {
    try {
      final response = await _httpClient.post(
        url: '$baseUrl/auth/v1/token?grant_type=password',
        headers: {
          'Content-Type': 'application/json',
          'apikey': anonKey,
        },
        data: {
          'email': email,
          'password': password,
        },
      );
      return Session.fromJson(response.data);
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'login'},
      ));
      return Session(
          accessToken: "",
          tokenType: "",
          expiresIn: 0,
          refreshToken: "",
          user: User());
    }
  }

  /// For logging out, the user will provide an email and
  /// password.
  /// The `logout` service method should expect a `User` object.
  /// The accessToken token of the user sending invites is added
  /// headers.
  Future<bool> logout({
    required String accessToken,
    required String baseUrl,
  }) async {
    try {
      final url = '$baseUrl/auth/v1/logout';
      final data = {'token': accessToken};
      final response = await _httpClient.post(url: url, data: data);
      return response.data;
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'logout'},
      ));
      return false;
    }
  }

  /// Refreshing the access token
  /// The `refreshToken` service method should expect a `User` object.
  /// The accessToken token of the user sending invites is added
  /// headers.
  Future<Session> refreshToken(String refreshToken, String baseUrl) async {
    try {
      final response = await _httpClient.post(
        url: '$baseUrl/auth/v1/token?grant_type=refresh_token',
        headers: {
          'Content-Type': 'application/json',
        },
        data: {
          'refresh_token': refreshToken,
        },
      );
      return Session.fromJson(response.data);
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'refreshToken'},
      ));
      return Session(
          accessToken: "",
          tokenType: "",
          expiresIn: 0,
          refreshToken: "",
          user: User());
    }
  }

  /// Validates a token by making an HTTP GET request to the server.
  /// Returns `true` if the token is valid, and `false` otherwise.
  Future<bool> validateToken(String token, String baseUrl) async {
    try {
      final response = await _httpClient.get(
        url: '$baseUrl/auth/v1/token/validate',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'validateToken'},
      ));
      return false;
    }
  }
}

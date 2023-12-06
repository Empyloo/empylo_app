/*
User Service to make networks calls for user related
operations. This includes invites, login, logout,
profile update, password reset, etc.
*/
// Path: lib/services/user_service.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/session.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/middleware/error_handling_middleware.dart';
import 'package:empylo_app/constants/endpoints.dart';

class UserService {
  final HttpClient _httpClient;
  final ErrorHandlingMiddleware _errorMiddleware;

  UserService({
    required HttpClient httpClient,
    required ErrorHandlingMiddleware errorMiddleware,
  })  : _httpClient = httpClient,
        _errorMiddleware = errorMiddleware;

  Future<Response> invites({
    required List<String> emails,
    String? organizationId,
    String? organizationName,
    String? role,
    String? accessToken,
  }) async {
    return _errorMiddleware.handleErrors(
      () async {
        return await _httpClient.post(
          url: Endpoints.invitesUrl,
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
      },
      'UserService.invites',
    );
  }

  Future<Session> login({
    required String email,
    required String password,
  }) async {
    return _errorMiddleware.handleErrors(
      () async {
        final response = await _httpClient.post(
          url: Endpoints.loginUrl,
          headers: {
            'Content-Type': 'application/json',
            'apikey': remoteAnonKey,
          },
          data: {
            'email': email,
            'password': password,
          },
        );
        return Session.fromJson(response.data);
      },
      'UserService.login',
    );
  }

  Future<bool> logout({
    required String accessToken,
  }) async {
    return _errorMiddleware.handleErrors(
      () async {
        const url = Endpoints.logoutUrl;
        final data = {'token': accessToken};
        final response = await _httpClient.post(url: url, data: data);
        return response.data;
      },
      'UserService.logout',
    );
  }

  Future<Session> refreshToken(String refreshToken, String baseUrl) async {
    return _errorMiddleware.handleErrors(
      () async {
        final response = await _httpClient.post(
          url: Endpoints.refreshTokenUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          data: {
            'refresh_token': refreshToken,
          },
        );
        return Session.fromJson(response.data);
      },
      'UserService.refreshToken',
    );
  }

  Future<bool> validateToken(String token, String baseUrl) async {
    return _errorMiddleware.handleErrors(
      () async {
        final response = await _httpClient.get(
          url: Endpoints.validateTokenUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        return response.statusCode == 200;
      },
      'UserService.validateToken',
    );
  }
}

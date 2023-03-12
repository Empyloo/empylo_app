// Path: lib/state_management/user_notifier.dart
import 'dart:async';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/state_management/cred_provider.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserState { loggedIn, loggedOut }

class UserNotifier extends StateNotifier<AsyncValue<UserState>> {
  final HttpClient _httpClient;
  final SentryService _sentry;
  final String _anonKey;
  final _baseUrl = 'https://fzfsoqhwjvaymlwbcppi.supabase.co';

  UserNotifier(httpClient, sentry, remoteAnonKey)
      : _httpClient = httpClient,
        _sentry = sentry,
        _anonKey = remoteAnonKey,
        super(const AsyncValue.loading());

  Future<void> login({
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      print('Logging in...');
      final response = await _httpClient.post(
        url: '$_baseUrl/auth/v1/token?grant_type=password',
        headers: {
          'Content-Type': 'application/json',
          'apikey': _anonKey,
        },
        data: {
          'email': email,
          'password': password,
        },
      );
      print('Login response: ${response.data}');
      final accessBox = await ref.read(accessBoxProvider.future);
      accessBox.put('session', response.data);
      state = const AsyncValue.data(UserState.loggedIn);
      // Update auth state and navigate to home page
      ref.read(authStateProvider.notifier).login();
      ref.watch(routerProvider).go('/home');
    } catch (e) {
      print('Error logging in: $e');
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'login'},
      ));
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Implement user logout
  Future<void> logout({required WidgetRef ref}) async {
    try {
      final url = '$_baseUrl/auth/v1/logout';
      final accessBox = await ref.read(accessBoxProvider.future);
      final session = accessBox.get('session');
      final data = {'token': session?['access_token']};
      await _httpClient.post(url: url, data: data);
      // Delete session data from Hive box
      accessBox.delete('session');
      // Update auth state
      ref.read(authStateProvider.notifier).logout();
      state = const AsyncValue.data(UserState.loggedOut);
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'logout'},
      ));
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Implement refresh token
  Future<void> refreshToken(
      {required String token, required WidgetRef ref}) async {
    try {
      final response = await _httpClient.post(
        url: '$_baseUrl/auth/v1/token?grant_type=refresh_token',
        headers: {
          'Content-Type': 'application/json',
        },
        data: {
          'refresh_token': token,
        },
      );
      final accessBox = await ref.read(accessBoxProvider.future);
      accessBox.put('session', response.data);
      state = const AsyncValue.data(UserState.loggedIn);
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'refreshToken'},
      ));

      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // A method that validates an access token by getting the user details
  Future<bool> validateToken({
    required String accessToken,
    required WidgetRef ref,
  }) async {
    try {
      final url = '$_baseUrl/auth/v1/user';
      final response = await _httpClient.get(
        url: url,
      );
      // check response is in 200 range
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'validateToken'},
      ));

      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}

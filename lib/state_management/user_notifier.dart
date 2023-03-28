// Path: lib/state_management/user_notifier.dart
import 'dart:async';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/state_management/login_state_provider.dart';
import 'package:empylo_app/state_management/mfa_service_provider.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/ui/molecules/dialogues/code_dialog.dart';
import 'package:empylo_app/ui/molecules/dialogues/mfa_dialog.dart';
import 'package:empylo_app/ui/molecules/dialogues/remove_factor_dialog.dart';
import 'package:empylo_app/utils/get_user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserState { loggedIn, loggedOut }

typedef ShowFactorsDialogCallback = Future<void> Function(
    String accessToken, List<dynamic> factors);

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

  void showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red.shade300,
      ),
    );
  }

  bool isUserEnrolled(Map<String, dynamic> response) {
    return response['user']?['factors'] != null;
  }

  bool isFactorVerified(Map<String, dynamic> response) {
    if (response['user'] != null &&
        response['user']['factors'] != null &&
        response['user']['factors'].isNotEmpty) {
      return response['user']['factors'][0]['status'] == 'verified';
    } else {
      return false;
    }
  }

  int getFactorsLength(Map<String, dynamic> response) {
    List<dynamic>? factors = response['user']?['factors'];
    return factors?.length ?? 0;
  }

  /// Given the userRole, mfaRequired, isEnrolled and isVerified, return the appropriate [UserState]

  Future<void> login({
    required String email,
    required String password,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic>? sessionData;
      print('Logging in...');
      ref.read(loginStateProvider.notifier).toggleLoading();
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
      UserRole userRole = getUserRoleFromResponse(response.data);
      final bool mfaRequired =
          userRole == UserRole.admin || userRole == UserRole.superAdmin;
      final bool isEnrolled = isUserEnrolled(response.data);
      print('User enrolled: $isEnrolled');
      final bool isVerified = isFactorVerified(response.data);
      // if the user is enrolled and factor is verified, then we can challengeAndVerifyMFA
      // if the user is enrolled and factor is not verified, then we can enrollAndVerifyMFA
      print('MFA required: $mfaRequired');
      ref.read(loginStateProvider.notifier).toggleLoading();
      if (getFactorsLength(response.data) >= 9) {
        print('User has 9 or more factors. Removing factor...');
        ref.watch(routerProvider).go('/factors');
      } else if ((!isEnrolled && mfaRequired) || (isEnrolled && !isVerified)) {
        print('Setting up MFA...');
        final sessionData = await ref
            .read(mfaServiceProvider)
            .enrollAndVerifyMFA(
              ref: ref,
              accessToken: response.data['access_token'],
              showDialogFn: () async {
                return await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return const MFADialog();
                  },
                );
              },
            )
            .catchError((error) {
          showErrorSnackBar(context, 'MFA verification failed');
          return null;
        });
      } else if (isEnrolled) {
        print('Is enrolled, verifying MFA...');
        ref.read(loginStateProvider.notifier).toggleDialogState(true);
        final sessionData = await ref
            .read(mfaServiceProvider)
            .verifiedChallengeFlow(
              ref: ref,
              accessToken: response.data['access_token'],
              user: response.data['user'],
              showDialogFn: () async {
                return await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return const CodeDialog();
                  },
                );
              },
            )
            .catchError((error) {
          showErrorSnackBar(context, 'MFA verification failed');
          return null;
        });
        ref.read(loginStateProvider.notifier).toggleDialogState(true);
      } else {
        print('MFA not required');
      }
      state = const AsyncValue.data(UserState.loggedIn);
      ref.read(authStateProvider.notifier).login(userRole);
      final accessBox = await ref.read(accessBoxProvider.future);
      accessBox.put('session', sessionData);
      ref.watch(routerProvider).go('/home');
    } catch (e) {
      print('Error logging in: $e');
      showErrorSnackBar(context, 'Error logging in, please try again.');
      ref.watch(routerProvider).go('/login');
    }
  }

  // Implement user logout
  Future<void> logout({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
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
      showErrorSnackBar(context, 'Error logging out, please try again.');
    }
  }

  // Implement refresh token
  Future<void> refreshToken({
    required String accessToken,
    required String token,
    required WidgetRef ref,
  }) async {
    try {
      final response = await _httpClient.post(
        url: '$_baseUrl/auth/v1/token?grant_type=refresh_token',
        headers: {
          'Content-Type': 'application/json',
          'apikey': _anonKey,
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          'refresh_token': token,
        },
      );
      print('Refresh token response: ${response.data}');
      if (response.data['user'] != null) {
        final accessBox = await ref.read(accessBoxProvider.future);
        accessBox.put('session', response.data);
        state = const AsyncValue.data(UserState.loggedIn);
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error refreshing token: $e',
          level: 'error',
          extra: {'access_token': token, 'refresh_token': token},
        ),
      );
    }
  }

  // Implement validate token
  Future<bool> validateToken({
    required String accessToken,
    required String refreshToken,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      final response = await _httpClient.get(
        url: '$_baseUrl/auth/v1/user',
        headers: {
          'apikey': _anonKey,
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print('Validate token response: ${response.data}');
      if (response.data['id'] != null) {
        state = const AsyncValue.data(UserState.loggedIn);
        return true;
      } else if (response.data['error'] == 'invalid_token') {
        await this.refreshToken(
          accessToken: accessToken,
          token: refreshToken,
          ref: ref,
        );
        return true;
      } else {
        await _sentry.sendErrorEvent(
          ErrorEvent(
            message: 'Token validation failed',
            level: 'error',
            extra: {
              'session': response.data,
              'url': '$_baseUrl/auth/v1/user',
            },
          ),
        );
        throw Exception('Token validation failed');
      }
    } catch (e) {
      print('Error validating token: $e');
      print('Error token: $accessToken');
      print('Error refresh token: $refreshToken');
      print('Error url: $_baseUrl/auth/v1/user');
      showErrorSnackBar(context, 'Error with token.');
      return false;
    }
  }

  // Inside UserNotifier class
  Future<String?> showMFADialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return const MFADialog();
      },
    );
  }
}

// Path: lib/state_management/user_notifier.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/state_management/login_state_provider.dart';
import 'package:empylo_app/state_management/mfa_service_provider.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/dialogues/code_dialog.dart';
import 'package:empylo_app/ui/molecules/dialogues/mfa_dialog.dart';
import 'package:empylo_app/utils/user_utils/get_user_role.dart';
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
        backgroundColor: Colors.red.shade200,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Function(BuildContext) getErrorCallback(WidgetRef ref) {
    return (BuildContext context) {
      showErrorSnackBar(context, 'MFA verification failed');
      ref.read(loginStateProvider.notifier).toggleLoading();
      ref.read(routerProvider).go('/');
    };
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

  Future<void> navigateToUserProfileOrHome(
      WidgetRef ref, UserProfile? userProfile) async {
    if (userProfile?.acceptedTerms == true) {
      ref.read(routerProvider).go('/home');
    } else {
      ref.read(routerProvider).go('/user-profile?id=${userProfile?.id}');
    }
  }

  Future<void> allowAccess(BuildContext context, WidgetRef ref,
      Map<String, dynamic> responseData, UserRole userRole) async {
    state = const AsyncValue.data(UserState.loggedIn);
    ref.read(authStateProvider.notifier).login(userRole);

    // Fetch the user profile
    final userProfileNotifier = ref.read(userProfileNotifierProvider.notifier);
    await userProfileNotifier.getUserProfile(
        responseData['user']['id'], responseData['access_token']);

    // Check if the user has accepted the terms
    final UserProfile? userProfile = ref.read(userProfileNotifierProvider);
    ref.read(loginStateProvider.notifier).clearTextFields();

    await navigateToUserProfileOrHome(ref, userProfile);
  }

  void denyAccess(BuildContext context, WidgetRef ref) {
    ref.read(loginStateProvider.notifier).toggleLoading();
    showErrorSnackBar(context,
        'Error logging in, please check your credentials and try again.');
    ref.read(routerProvider).go('/');
  }

  Future<void> login({
    required String email,
    required String password,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      ref.read(loginStateProvider.notifier).toggleLoading();

      _httpClient.post(
        url: '$_baseUrl/auth/v1/token?grant_type=password',
        headers: {
          'Content-Type': 'application/json',
          'apikey': _anonKey,
        },
        data: {
          'email': email,
          'password': password,
        },
      ).then((response) {
        UserRole userRole = getUserRoleFromResponse(response.data);
        final bool mfaRequired =
            userRole == UserRole.admin || userRole == UserRole.superAdmin;

        if (mfaRequired) {
          handleMfaFlow(
            context,
            ref,
            response.data,
            userRole,
            getErrorCallback(ref),
          ).catchError((_) {
            ref.read(loginStateProvider.notifier).toggleLoading();
          });
        } else {
          ref.read(loginStateProvider.notifier).toggleLoading();
          allowAccess(context, ref, response.data, userRole);
        }
      }).catchError((error) {
        ref.read(loginStateProvider.notifier).toggleLoading();
        denyAccess(context, ref);
      });
    } catch (e) {
      ref.read(loginStateProvider.notifier).toggleLoading();
      denyAccess(context, ref);
    } finally {
      ref.read(loginStateProvider.notifier).toggleLoading();
    }
  }

  // Inside UserNotifier class
  void loginWithToken({
    required String accessToken,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    _httpClient.get(
      url: '$_baseUrl/auth/v1/user',
      headers: {
        'Content-Type': 'application/json',
        'apikey': _anonKey,
        'Authorization': 'Bearer $accessToken',
      },
    ).then((response) {
      if (response.data['user'] != null) {
        UserRole userRole = getUserRoleFromResponse(response.data);
        allowAccess(context, ref, response.data, userRole);
      } else {
        throw Exception('Token login failed');
      }
    }).catchError((_) {
      denyAccess(context, ref);
    });
  }

  Future<void> handleMfaFlow(
      BuildContext context,
      WidgetRef ref,
      Map<String, dynamic> responseData,
      UserRole userRole,
      Function(BuildContext) errorCallback) async {
    final bool isEnrolled = isUserEnrolled(responseData);
    final bool isVerified = isFactorVerified(responseData);

    if (getFactorsLength(responseData) >= 9) {
      ref.read(routerProvider).go('/factors');
    } else if (!isEnrolled || !isVerified) {
      return enrollAndVerifyMfa(context, ref, responseData, errorCallback);
    } else {
      return verifiedChallengeFlow(
          context, ref, responseData, userRole, errorCallback);
    }
  }

  void enrollAndVerifyMfa(
      BuildContext context,
      WidgetRef ref,
      Map<String, dynamic> responseData,
      Function(BuildContext) errorCallback) async {
    try {
      await ref.read(mfaServiceProvider).enrollAndVerifyMFA(
            ref: ref,
            accessToken: responseData['access_token'],
            showDialogFn: () async {
              final String? code = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return const MFADialog();
                },
              );
              if (code == null || code.isEmpty) {
                throw Exception("MFA code not provided");
              }
              return code;
            },
          );
    } catch (error) {
      errorCallback(context);
    }
  }

  void verifiedChallengeFlow(
      BuildContext context,
      WidgetRef ref,
      Map<String, dynamic> responseData,
      UserRole userRole,
      Function(BuildContext) errorCallback) async {
    ref.read(loginStateProvider.notifier).toggleDialogState(true);
    try {
      final sessionData =
          await ref.read(mfaServiceProvider).verifiedChallengeFlow(
                ref: ref,
                accessToken: responseData['access_token'],
                user: responseData['user'],
                showDialogFn: () async {
                  final String? code = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return const CodeDialog();
                    },
                  );
                  if (code == null || code.isEmpty) {
                    throw Exception("MFA code not provided");
                  }
                  return code;
                },
              );

      if (sessionData != null) {
        ref.read(loginStateProvider.notifier).toggleDialogState(true);
        await ref.read(accessBoxProvider.future).then((accessBox) async {
          accessBox.put('session', sessionData);
          await allowAccess(context, ref, responseData, userRole);
        });
      } else {
        ref.read(loginStateProvider.notifier).toggleDialogState(false);
        ref.read(routerProvider).go('/');
      }
    } catch (error) {
      errorCallback(context);
      ref.read(loginStateProvider.notifier).toggleDialogState(false);
      ref.read(routerProvider).go('/');
    }
  }

  Future<void> fetchUserProfile(Response response, WidgetRef ref) async {
    final userProfileNotifier = ref.read(userProfileNotifierProvider.notifier);
    await userProfileNotifier.getUserProfile(
        response.data['user']['id'], response.data['access_token']);
  }

  void navigateToNextPage(WidgetRef ref) {
    final UserProfile? userProfile = ref.read(userProfileNotifierProvider);
    ref.read(loginStateProvider.notifier).clearTextFields();
    if (userProfile?.acceptedTerms == true) {
      ref.read(routerProvider).go('/home');
    } else {
      ref.read(routerProvider).go('/user-profile?id=${userProfile?.id}');
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

  // Add the password reset method
  Future<void> passwordReset({
    required String email,
    required BuildContext context,
    required Function(String, Color) showSnackBarCallback,
  }) async {
    try {
      final response = await _httpClient.post(
        url: '$_baseUrl/auth/v1/recover',
        headers: {
          'Content-Type': 'application/json',
          'apikey': _anonKey,
        },
        data: {
          'email': email,
        },
      );
      if (response.statusCode == 200) {
        showSnackBarCallback(
          'Password reset email has been sent.',
          Colors.green.shade200,
        );
      }
    } catch (e) {
      showErrorSnackBar(context, 'Error resetting password, please try again.');
    }
  }

  // Add the setPassword method
  Future<void> setPassword({
    required String password,
    required String accessToken,
    required BuildContext context,
    required Function(String, Color) showSnackBarCallback,
  }) async {
    try {
      final response = await _httpClient.put(
        url: '$_baseUrl/auth/v1/user',
        headers: {
          'Content-Type': 'application/json',
          'apikey': _anonKey,
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        showSnackBarCallback(
          'Password has been successfully updated.',
          Colors.green.shade200,
        );
      } else {
        throw Exception(
            'Error setting password, status code: ${response.statusCode}');
      }
    } catch (e) {
      showErrorSnackBar(context, 'Error setting password, please try again.');
    }
  }

  // Implement refresh token
  Future<void> refreshToken({
    required String token,
    required WidgetRef ref,
  }) async {
    try {
      final response = await _httpClient.post(
        url: '$_baseUrl/auth/v1/token?grant_type=refresh_token',
        headers: {
          'Content-Type': 'application/json',
          'apikey': _anonKey,
          // 'Authorization': 'Bearer $accessToken',
        },
        data: {
          'refresh_token': token,
        },
      );
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
      if (response.data['id'] != null) {
        state = const AsyncValue.data(UserState.loggedIn);
        return true;
      }
      return false;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await this.refreshToken(
          token: refreshToken,
          ref: ref,
        );
        return true;
      } else {
        await _sentry.sendErrorEvent(
          ErrorEvent(
            message: 'Token validation and refresh failed.',
            level: 'error',
            extra: {
              'session': e.response?.data,
              'url': '$_baseUrl/auth/v1/user',
            },
          ),
        );
        throw Exception('Token validation failed');
      }
    } catch (e) {
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

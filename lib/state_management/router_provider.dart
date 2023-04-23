// Path: lib/services/router_provider.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/ui/pages/dashboard/dash.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/ui/pages/home/home.dart';
import 'package:empylo_app/ui/pages/login/factors_page.dart';
import 'package:empylo_app/ui/pages/login/password_reset_page.dart';
import 'package:empylo_app/ui/pages/login/set_password_page.dart';
import 'package:empylo_app/ui/pages/user/user_profile_page.dart';
import 'package:empylo_app/utils/get_query_params.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:empylo_app/ui/pages/login/login_page.dart';

/// A provider that exposes the [GoRouter] instance
/// to the rest of the app.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        name: 'login',
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (context, state) {
          final authState = ref.watch(authStateProvider);
          print('Going to profile page');
          print('Auth State: ${authState.isAuthenticated}');
          if (authState.isAuthenticated) {
            return const ProfilePage();
          } else {
            return const ErrorPage(
                'You do not have permission to access this page.');
          }
        },
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) {
          final authState = ref.watch(authStateProvider);
          if (authState.isAuthenticated) {
            return const HomePage();
          } else {
            return const ErrorPage(
                'You do not have permission to access this page.');
          }
        },
      ),
      GoRoute(
        name: 'factors',
        path: '/factors',
        builder: (context, state) {
          final authState = ref.watch(authStateProvider);
          if (authState.isAuthenticated) {
            return const FactorsPage();
          } else {
            return const ErrorPage(
                'You do not have permission to access this page.');
          }
        },
      ),
      GoRoute(
        name: 'dashboard',
        path: '/dashboard',
        builder: (context, state) {
          final authState = ref.watch(authStateProvider);
          if ((authState.isAuthenticated) &&
              (authState.role == UserRole.admin ||
                  authState.role == UserRole.superAdmin)) {
            return const DashboardPage();
          } else {
            return const ErrorPage(
              'You do not have permission to access this page.',
            );
          }
        },
      ),
      GoRoute(
        name: 'password-reset',
        path: '/password-reset',
        builder: (context, state) => const PasswordResetPage(),
      ),
      GoRoute(
        name: 'set-password',
        path: '/set-password',
        builder: (context, state) {
          final Map<String, String> tokens = extractTokensFromUrl();
          print('Tokens: $tokens');
          if (tokens.containsKey('access_token') &&
              tokens.containsKey('refresh_token')) {
            return SetPasswordPage(
              accessToken: tokens['access_token']!,
              refreshToken: tokens['refresh_token']!,
            );
          } else {
            return const ErrorPage(
              'You do not have permission to access this page.',
            );
          }
        },
      ),
    ],
  );
});

String _getInitialLocation() {
  final baseUri = Uri.base;
  final path = baseUri.path;
  final queryParameters = baseUri.queryParameters;
  final queryString = queryParameters.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
      .join('&');
  final newPath = path + (queryString.isNotEmpty ? '?$queryString' : '');
  return newPath;
}

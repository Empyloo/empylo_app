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
import 'package:empylo_app/utils/token_validation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:empylo_app/ui/pages/login/login_page.dart';

/// A provider that exposes the [GoRouter] instance
/// to the rest of the app.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: _getInitialLocation(),
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
          if (authState.isAuthenticated) {
            return const ProfilePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) {
          if (authState.isAuthenticated) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      GoRoute(
        name: 'factors',
        path: '/factors',
        builder: (context, state) {
          if (authState.isAuthenticated) {
            return const FactorsPage();
          } else {
            return const LoginPage();
          }
        },
      ),
      GoRoute(
        name: 'dashboard',
        path: '/dashboard',
        builder: (context, state) {
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
            if (tokens.isEmpty ||
                !tokens.containsKey('access_token') ||
                !tokens.containsKey('refresh_token')) {
              return const ErrorPage(
                'You do not have permission to access this page.',
              );
            }
            print('Tokens: $tokens');
            // If there are tokens, try to validate them
            if (tokens.containsKey('access_token') &&
                tokens.containsKey('refresh_token')) {
              handleTokenValidation(
                accessToken: tokens['access_token']!,
                refreshToken: tokens['refresh_token']!,
                ref: ref,
                context: context,
              );
            }
            return SetPasswordPage(
              accessToken: tokens['access_token']!,
              refreshToken: tokens['refresh_token']!,
            );
          }),
    ],
    redirect: (context, state) {
      print('Current subloc: ${state.subloc}');
      return null;
    },
  );
});

String _getInitialLocation() {
  final baseUri = Uri.base;
  final uriFragment = Uri.decodeFull(baseUri.fragment).replaceAll('#', '?');
  return baseUri.path + uriFragment;
}

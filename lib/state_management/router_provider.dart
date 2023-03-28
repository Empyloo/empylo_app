// Path: lib/services/router_provider.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/ui/pages/dashboard/dash.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/ui/pages/home/home.dart';
import 'package:empylo_app/ui/pages/login/factors_page.dart';
import 'package:empylo_app/ui/pages/login/pass_reset_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:empylo_app/ui/pages/login/login_page.dart';

/// A provider that exposes the [GoRouter] instance
/// to the rest of the app.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'login',
        path: '/',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) {
          if (authState.isAuthenticated) {
            return const HomePage();
          } else {
            return LoginPage();
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
            return LoginPage();
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
        name: 'password',
        path: '/password',
        builder: (context, state) => const PasswordResetPage(),
      ),
    ],
    redirect: (context, state) {
      if (!state.subloc.startsWith('/password') &&
          !authState.isAuthenticated &&
          !state.subloc.startsWith('/')) {
        return '/';
      }
      return null;
    },
  );
});

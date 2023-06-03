// Path: lib/services/router_provider.dart
// import 'package:empylo_app/dev_main.dart';
import 'package:empylo_app/models/redirect_params.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/users/admin_edit_user_notifier.dart';
import 'package:empylo_app/ui/molecules/widgets/companies/company_profile_page.dart';
import 'package:empylo_app/ui/pages/dashboard/dash.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/ui/pages/home/home.dart';
import 'package:empylo_app/ui/pages/login/factors_page.dart';
import 'package:empylo_app/ui/pages/login/password_reset_page.dart';
import 'package:empylo_app/ui/pages/login/set_password_page.dart';
import 'package:empylo_app/ui/pages/user/user_profile_page.dart';
import 'package:empylo_app/ui/pages/user_management/admin_user_edit_page.dart';
import 'package:empylo_app/utils/get_query_params.dart';
import 'package:empylo_app/utils/user_utils/get_user_profile_by_id.dart';
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
          builder: (context, state) {
            return const LoginPage(); //const ShowPage();
          }),
      GoRoute(
        name: 'user-profile',
        path: '/user-profile',
        builder: (context, state) => UserProfilePage(),
      ),
      GoRoute(
        name: 'admin-user-edit',
        path: '/admin-user-edit',
        builder: (context, state) {
          if (!state.queryParameters.containsKey('id')) {
            return const ErrorPage('Missing user ID parameter.');
          }
          final authState = ref.watch(authStateProvider);
          if (authState.isAuthenticated &&
              (authState.role == UserRole.admin ||
                  authState.role == UserRole.superAdmin)) {
            return AdminUserEditPage();
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
        name: 'company-profile',
        path: '/company-profile',
        builder: (context, state) {
          final authState = ref.watch(authStateProvider);
          final companyId = state.queryParameters['id']!;
          if (authState.isAuthenticated &&
              (authState.role == UserRole.admin ||
                  authState.role == UserRole.superAdmin)) {
            return CompanyProfilePage(companyId: companyId);
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
          RedirectParams? params = getQueryParams(Uri.base);
          if (params != null) {
            return SetPasswordPage(redirectParams: params);
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

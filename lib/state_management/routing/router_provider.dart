// Path: lib/services/router_provider.dart
import 'package:empylo_app/dev_main.dart';
import 'package:empylo_app/models/redirect_params.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/ui/molecules/widgets/companies/company_profile_page.dart';
import 'package:empylo_app/ui/pages/dashboard/dash.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/ui/pages/home/home.dart';
import 'package:empylo_app/ui/pages/login/factors_page.dart';
import 'package:empylo_app/ui/pages/login/password_reset_page.dart';
import 'package:empylo_app/ui/pages/login/set_password_page.dart';
import 'package:empylo_app/ui/pages/survey/survey.dart';
import 'package:empylo_app/ui/pages/user/user_profile_page.dart';
import 'package:empylo_app/ui/pages/user_management/admin_user_edit_page.dart';
import 'package:empylo_app/utils/get_query_params.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// A provider that exposes the [GoRouter] instance
/// to the rest of the app.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
          name: 'login',
          path: '/',
          builder: (context, state) {
            return const ShowPage(); // const LoginPage(); //const ShowPage();
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
          if (!state.uri.queryParameters.containsKey('id')) {
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
          final companyId = state.uri.queryParameters['id']!;
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
      GoRoute(
        name: 'survey',
        path: '/survey',
        builder: (context, state) {
          final uri = Uri.base;
          final decodedFragment =
              Uri.decodeFull(uri.fragment).replaceAll('#', '?');
          final uriObject = Uri.parse(decodedFragment);

          Map<String, String> queryParams =
              Map<String, String>.from(uriObject.queryParameters);

          if (queryParams.containsKey('surveyId')) {
            List<String> surveyIdAndToken = queryParams['surveyId']!.split('?');
            if (surveyIdAndToken.length > 1) {
              queryParams['surveyId'] = surveyIdAndToken[0];
              queryParams['access_token'] = surveyIdAndToken[1].split('=')[1];
            }
          }
          if (queryParams.containsKey('access_token')) {
            return SurveyPage(queryParams: queryParams);
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

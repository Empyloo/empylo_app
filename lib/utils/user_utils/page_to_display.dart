// Path: lib/utils/user_utils/page_to_display.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/ui/pages/user/user_profile_page.dart';
import 'package:empylo_app/utils/user_utils/is_authanticated.dart';
import 'package:empylo_app/utils/user_utils/retrieve_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Widget decidePageToDisplay(
    BuildContext context, ProviderRef ref, GoRouterState state) {
  UserProfile? userProfile = retrieveUserProfile(context, ref, state);

  if (isAuthenticated(context, ref) && userProfile != null) {
    return UserProfilePage();
  } else {
    return const ErrorPage('You do not have permission to access this page.');
  }
}

// Path: lib/utils/user_utils/retrieve_user_profile.dart
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';

UserProfile? retrieveUserProfile(
    BuildContext context, ProviderRef ref, GoRouterState state) {
  final userProfilesList = ref.watch(userProfilesListProvider);
  final userProfileNotifier = ref.watch(userProfileNotifierProvider);
  final userId = state.queryParameters['id']!;

  UserProfile? userProfile;
  try {
    userProfile = userProfilesList.firstWhere(
      (profile) => profile.id == userId,
    );
  } catch (_) {
    userProfile = null;
  }

  userProfile ??=
      (userProfileNotifier?.id == userId ? userProfileNotifier : null);

  return userProfile;
}

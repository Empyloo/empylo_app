// Path: lib/state_management/user_access_checker_provider.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userAccessCheckerProvider =
    Provider.family<bool, UserProfile>((ref, user) {
  final authState = ref.watch(authStateProvider);
  final userProfile = ref.watch(userProfileNotifierProvider);

  if (userProfile != null && userProfile.id == user.id) {
    return true;
  }

  if (authState.role == UserRole.superAdmin) {
    return true;
  }

  if (authState.role == UserRole.admin &&
      userProfile != null &&
      userProfile.companyID == user.companyID) {
    return true;
  }

  return false;
});

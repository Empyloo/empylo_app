// Path: lib/state_management/user_access_checker_provider.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userAccessCheckerProvider =
    Provider.family<bool, String>((ref, userId) {
  final authState = ref.watch(authStateProvider);
  final userProfile = ref.watch(userProfileNotifierProvider);

  if (userProfile != null && userProfile.id == userId) {
    return true;
  }

  if (authState.role == UserRole.superAdmin) {
    return true;
  }

  if (authState.role == UserRole.admin &&
      userProfile != null &&
      userProfile.companyID == userId) {
    return true;
  }

  return false;
});

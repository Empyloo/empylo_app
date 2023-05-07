// Path: lib/state_management/company_access_checker_provider.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final companyAccessCheckerProvider =
    Provider.family<bool, String>((ref, companyId) {
  final authState = ref.watch(authStateProvider);
  final userProfile = ref.watch(userProfileNotifierProvider);

  if (authState.role == UserRole.superAdmin) {
    return true;
  }

  if (authState.role == UserRole.admin &&
      userProfile != null &&
      userProfile.companyID == companyId) {
    return true;
  }

  return false;
});

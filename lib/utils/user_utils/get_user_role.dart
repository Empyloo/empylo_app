// Path: lib/utils/get_user_role.dart

import 'package:empylo_app/state_management/auth_state_notifier.dart';

UserRole getUserRoleFromResponse(Map<String, dynamic> response) {
  String role = response['user']['app_metadata']['role'];

  switch (role) {
    case 'admin':
      return UserRole.admin;
    case 'super_admin':
      return UserRole.superAdmin;
    default:
      return UserRole.user;
  }
}

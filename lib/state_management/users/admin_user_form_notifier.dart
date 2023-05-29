// Path: lib/state_management/users/admin_user_form_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminUserFormNotifier extends StateNotifier<bool> {
  AdminUserFormNotifier() : super(false);

  void setHasChanges(bool value) {
    state = value;
  }
}

final adminUserFormHasChangesProvider =
    StateNotifierProvider<AdminUserFormNotifier, bool>(
        (ref) => AdminUserFormNotifier());

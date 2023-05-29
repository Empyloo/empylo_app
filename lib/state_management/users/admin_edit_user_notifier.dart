// Path: lib/state_management/users/admin_edit_user_notifier.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminEditUserNotifier extends StateNotifier<UserProfile?> {
  final UserProfilesList _userProfilesList;

  AdminEditUserNotifier(this._userProfilesList) : super(null);

  void setUserProfile(UserProfile userProfile) {
    state = userProfile;
  }

  Future<void> updateUserProfile(
      String id, Map<String, dynamic> updates, String accessToken) async {
    try {
      await _userProfilesList.updateUserProfile(id, updates, accessToken);
      updateState(updates);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserProfile(String id, String accessToken) async {
    try {
      await _userProfilesList.deleteUserProfile(id, accessToken);
      state = null;
    } catch (e) {
      rethrow;
    }
  }

  void updateState(Map<String, dynamic> updates) {
    final updatedUserProfile = state?.fromMap(updates);
    if (updatedUserProfile != null) {
      state = updatedUserProfile;
    }
  }
}

final adminEditUserNotifierProvider =
    StateNotifierProvider<AdminEditUserNotifier, UserProfile?>((ref) {
  final userProfilesList = ref.watch(userProfilesListProvider.notifier);
  return AdminEditUserNotifier(userProfilesList);
});

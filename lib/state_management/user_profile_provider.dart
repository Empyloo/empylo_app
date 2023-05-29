// Path: lib/state_management/user_profile_provider.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/services/user_rest_service.dart';
import 'package:empylo_app/state_management/user_rest_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final UserRestService _userService;

  UserProfileNotifier({required UserRestService userService})
      : _userService = userService,
        super(null);

  Future<void> getUserProfile(String id, String accessToken) async {
    try {
      final userProfile = await _userService.getUserProfile(id, accessToken);
      state = userProfile;
    } catch (e) {
      state = null;
      rethrow;
    }
  }

  Future<void> updateUserProfile(
      String id, Map<String, dynamic> updates, String accessToken) async {
    try {
      await _userService.updateUserProfile(id, updates, accessToken);
      final updatedUserProfile = state?.fromMap(updates);
      state = updatedUserProfile;
    } catch (e) {
      state = null;
      rethrow;
    }
  }

  void deleteUserProfile(String id, String accessToken) {
    try {
      _userService.deleteUserProfile(id, accessToken);
      state = null;
    } catch (e) {
      state = null;
      rethrow;
    }
  }

  void updateField(String field, dynamic value) {
    if (state != null) {
      final updates = {field: value};
      final updatedUserProfile = state?.fromMap(updates);
      state = updatedUserProfile;
    }
  }
}

final userProfileNotifierProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  final userService = ref.watch(userRestServiceProvider);
  return UserProfileNotifier(userService: userService);
});

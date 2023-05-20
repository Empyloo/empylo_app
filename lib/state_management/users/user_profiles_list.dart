// Path: lib/state_management/user_profiles_list.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/services/user_rest_service.dart';
import 'package:empylo_app/state_management/user_rest_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfilesList extends StateNotifier<List<UserProfile>> {
  final UserRestService _userService;

  UserProfilesList({required UserRestService userService})
      : _userService = userService,
        super([]);

  Future<void> getUserProfiles(String accessToken) async {
    try {
      final userProfiles = await _userService.getUserProfiles(accessToken);
      state = userProfiles;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  Future<void> updateUserProfile(
      String id, Map<String, dynamic> updates, String accessToken) async {
    try {
      await _userService.updateUserProfile(id, updates, accessToken);
      final updatedUserProfile = state
          .firstWhere((userProfile) => userProfile.id == id)
          .fromMap(updates);
      state = state
          .map((userProfile) =>
              userProfile.id == id ? updatedUserProfile : userProfile)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteUserProfile(String id, String accessToken) async {
    try {
      await _userService.deleteUserProfile(id, accessToken);
      state = state.where((userProfile) => userProfile.id != id).toList();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final userProfilesListProvider =
    StateNotifierProvider<UserProfilesList, List<UserProfile>>((ref) {
  final userService = ref.watch(userRestServiceProvider);
  return UserProfilesList(userService: userService);
});

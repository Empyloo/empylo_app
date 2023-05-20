// Path: lib/utils/user_utils/get_user_profile_by_id.dart

import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

UserProfile? getUserProfileById(ProviderRef ref, String userId) {
  final userProfilesList = ref.watch(userProfilesListProvider);
  try {
    return userProfilesList.firstWhere((profile) => profile.id == userId);
  } catch (_) {
    return null;
  }
}

// Path: lib/state_management/audiences/audience_users_list_provider.dart
import 'package:empylo_app/models/audience_member.dart';
import 'package:empylo_app/models/user_audience_link.dart';
import 'package:empylo_app/state_management/audiences/audience_member_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudienceMembersList
    extends StateNotifier<Map<String, List<AudienceMember>>> {
  final AudienceMemberNotifier _audienceMemberNotifier;

  AudienceMembersList(this._audienceMemberNotifier) : super({});

  Future<void> addUser(String audienceId, AudienceMember user,
      String accessToken, UserAudienceLink userAudienceLink) async {
    try {
      await _audienceMemberNotifier.addUserToAudience(
          accessToken, userAudienceLink);
      state = {
        ...state,
        audienceId: [
          ...(state[audienceId] ?? []),
          AudienceMember(
              audienceId: userAudienceLink.audienceId,
              email: userAudienceLink.userId) // use user ID
        ],
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUser(
      String audienceId,
      AudienceMember user,
      String accessToken,
      UserAudienceLink userAudienceLink,
      String userId) async {
    try {
      await _audienceMemberNotifier.removeUserFromAudience(
          accessToken, userAudienceLink, userId);
      state = {
        ...state,
        audienceId:
            state[audienceId]?.where((u) => u.email != user.email).toList() ??
                [], // compare user IDs
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getUsersInAudience(String audienceId, String accessToken,
      String userRole, String companyId) async {
    try {
      final audienceMembers = await _audienceMemberNotifier.getUsersInAudience(
          audienceId, accessToken, userRole, companyId);
      state = {...state, audienceId: audienceMembers};
    } catch (e) {
      rethrow;
    }
  }

  void resetState() {
    state = {};
  }
}

final audienceUsersListProvider = StateNotifierProvider<AudienceMembersList,
    Map<String, List<AudienceMember>>>((ref) {
  final audienceMemberNotifier =
      ref.read(audienceMemberNotifierProvider.notifier);
  return AudienceMembersList(audienceMemberNotifier);
});

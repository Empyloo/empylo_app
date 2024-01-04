// Path: lib/state_management/audiences/audience_member_notifier.dart
import 'package:empylo_app/models/audience_member.dart';
import 'package:empylo_app/models/user_audience_link.dart';
import 'package:empylo_app/services/http/http_client.dart';

import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audienceUserServiceProvider = Provider<AudienceUserService>((ref) {
  final HttpClient httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  return AudienceUserService(
    sentry: sentry,
    http: httpClient,
  );
});

final audienceMemberNotifierProvider =
    StateNotifierProvider<AudienceMemberNotifier, List<AudienceMember>>(
  (ref) {
    final audienceUserService = ref.read(audienceUserServiceProvider);
    return AudienceMemberNotifier(audienceUserService);
  },
);

class AudienceMemberNotifier extends StateNotifier<List<AudienceMember>> {
  final AudienceUserService _audienceUserService;

  AudienceMemberNotifier(this._audienceUserService) : super([]);

  Future<List<AudienceMember>> getUsersInAudience(String audienceId,
      String accessToken, String userRole, String companyId) async {
    try {
      final audienceMembers = await _audienceUserService.getUsersInAudience(
          audienceId, accessToken, userRole, companyId);
      state = audienceMembers;
      return audienceMembers;
    } catch (e) {
      throw Exception('Error fetching users in audience: $e');
    }
  }

  Future<void> addUserToAudience(
      String accessToken, UserAudienceLink userAudienceLink) async {
    try {
      await _audienceUserService.addUserToAudience(
          accessToken, userAudienceLink);
      state = [
        ...state,
        AudienceMember(
            audienceId: userAudienceLink.audienceId,
            email: userAudienceLink.userId) // use user ID
      ];
    } catch (e) {
      throw Exception('Error adding user to audience: $e');
    }
  }

  Future<void> removeUserFromAudience(String accessToken,
      UserAudienceLink userAudienceLink, String userId) async {
    try {
      await _audienceUserService.removeUserFromAudience(
          accessToken, userAudienceLink.audienceId, userId);
      state = state
          .where((member) =>
              member.email != userAudienceLink.userId) // compare user IDs
          .toList();
    } catch (e) {
      throw Exception('Error removing user from audience: $e');
    }
  }
}

// Path: lib/state_management/campaign_list_provider.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/services/campaign_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/campaigns/campaign_service_provider.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignListNotifier extends StateNotifier<List<Campaign>> {
  final CampaignsService campaignsService;

  CampaignListNotifier(this.campaignsService) : super([]);

  Future<String> getAccessToken(WidgetRef ref) async {
    final accessBox = await ref.watch(accessBoxProvider.future);
    return accessBox.get('session')['access_token'];
  }

  Future<bool> createCampaign(Campaign campaign, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      await campaignsService.createCampaign(
          accessToken: accessToken, campaign: campaign);
      await getCampaigns(ref, ref.read(userProfileNotifierProvider)!.companyID,
          ref.read(authStateProvider).role.name);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCampaign(Campaign updatedCampaign, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      await campaignsService.updateCampaign(
          campaign: updatedCampaign,
          accessToken: accessToken,
          userRole: ref.read(authStateProvider).role.name,
          companyId: ref.read(userProfileNotifierProvider)!.companyID);
      state = [
        for (final campaign in state)
          if (campaign.id == updatedCampaign.id) updatedCampaign else campaign
      ];
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteCampaign(String id, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      final user = ref.read(userProfileNotifierProvider);
      final userRole = ref.read(authStateProvider).role.name;
      await campaignsService.deleteCampaign(
          accessToken, user!.companyID, userRole, id);
      state = state.where((campaign) => campaign.id != id).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getCampaigns(
      WidgetRef ref, String companyId, String userRole) async {
    try {
      final accessToken = await getAccessToken(ref);
      final fetchedCampaigns = await campaignsService.getCampaigns(
        companyId,
        accessToken,
        userRole,
      );
      state = [...fetchedCampaigns];
    } catch (e) {
      rethrow;
    }
  }
}

final campaignListNotifierProvider =
    StateNotifierProvider<CampaignListNotifier, List<Campaign>>((ref) {
  final campaignsService = ref.watch(campaignsServiceProvider);
  return CampaignListNotifier(campaignsService);
});

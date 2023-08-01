// Path: lib/state_management/campaign_list_provider.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/services/campaign_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/campaigns/campaign_service_provider.dart';
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
      final newCampaign = await campaignsService.createCampaign(
          accessToken: accessToken, campaign: campaign);
      state = [...state, Campaign.fromJson(newCampaign.data)];
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCampaign(
      String id, Campaign updatedCampaign, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      await campaignsService.updateCampaign(
          campaignId: id, campaign: updatedCampaign, accessToken: accessToken);
      state = [
        for (final campaign in state)
          if (campaign.id == id) updatedCampaign else campaign
      ];
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteCampaign(String id, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      await campaignsService.deleteCampaign(accessToken, id);
      state = state.where((campaign) => campaign.id != id).toList();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final campaignListNotifierProvider =
    StateNotifierProvider<CampaignListNotifier, List<Campaign>>((ref) {
  final campaignsService = ref.watch(campaignsServiceProvider);
  return CampaignListNotifier(campaignsService);
});

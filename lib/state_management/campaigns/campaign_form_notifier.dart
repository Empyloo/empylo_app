// Path: lib/state_management/campaign_form_provider.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/services/campaign_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/campaigns/campaign_list_notifier.dart';
import 'package:empylo_app/state_management/campaigns/campaign_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignFormNotifier extends StateNotifier<Campaign> {
  final CampaignsService campaignsService;

  CampaignFormNotifier(this.campaignsService)
      : super(Campaign(
          name: '',
          count: 0,
          threshold: 0,
          status: 'active',
          companyId: '',
          createdBy: '',
          nextRunTime: DateTime.now(),
          type: null,
        ));

  Future<String> getAccessToken(WidgetRef ref) async {
    final accessBox = await ref.watch(accessBoxProvider.future);
    return accessBox.get('session')['access_token'];
  }

  Future<bool> createCampaign(Map<String, dynamic> data, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      final campaign = await campaignsService.createCampaign(
          campaign: Campaign.fromJson(data), accessToken: accessToken);
      state = Campaign.fromJson(campaign.data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCampaign(
      String id, Map<String, dynamic> data, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      final updatedCampaign = await campaignsService.updateCampaign(
          campaignId: id,
          campaign: Campaign.fromJson(data),
          accessToken: accessToken);
      state = Campaign.fromJson(updatedCampaign.data);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteCampaign(String id, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      await campaignsService.deleteCampaign(accessToken, id);
      return true;
    } catch (e) {
      return false;
    }
  }

  void reset() {
    state = Campaign(
      name: '',
      count: 0,
      threshold: 0,
      status: 'active',
      companyId: '',
      createdBy: '',
      nextRunTime: DateTime.now(),
    );
  }
}

final campaignFormNotifierProvider =
    StateNotifierProvider<CampaignFormNotifier, Campaign>(
  (ref) {
    final campaignsService = ref.watch(campaignsServiceProvider);
    return CampaignFormNotifier(campaignsService);
  },
);

final campaignFormChangedProvider = Provider.autoDispose((ref) {
  final campaignForm = ref.watch(campaignFormNotifierProvider);
  return campaignForm;
});

final campaignProvider = Provider.family<Campaign, String>((ref, campaignId) {
  final campaignList = ref.watch(campaignListNotifierProvider);
  return campaignList
      .firstWhere((campaign) => campaign.companyId == campaignId);
});

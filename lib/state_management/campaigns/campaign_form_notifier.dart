// Path: lib/state_management/campaign_form_provider.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/services/campaign_service.dart';
import 'package:empylo_app/state_management/campaigns/campaign_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignFormNotifier extends StateNotifier<Campaign> {
  final CampaignListNotifier campaignListNotifier;

  CampaignFormNotifier(this.campaignListNotifier)
      : super(Campaign(
          name: '',
          count: 0,
          threshold: 0,
          status: 'active',
          companyId: '',
          createdBy: '',
          nextRunTime: DateTime.now(),
          type: '',
        ));

  Future<bool> createCampaign(Map<String, dynamic> data, WidgetRef ref) async {
    try {
      final campaign = Campaign.fromJson(data);
      return await campaignListNotifier.createCampaign(campaign, ref);
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCampaign(
      String id, Map<String, dynamic> data, WidgetRef ref) async {
    try {
      final updatedCampaign = Campaign.fromJson(data);
      return await campaignListNotifier.updateCampaign(
          updatedCampaign, ref);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteCampaign(String id, WidgetRef ref) async {
    return await campaignListNotifier.deleteCampaign(id, ref);
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
      type: '',
    );
  }
}

final campaignFormNotifierProvider =
    StateNotifierProvider<CampaignFormNotifier, Campaign>(
  (ref) {
    final campaignListNotifier =
        ref.watch(campaignListNotifierProvider.notifier);
    return CampaignFormNotifier(campaignListNotifier);
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

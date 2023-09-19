// Path: lib/ui/molecules/widgets/campaigns/cards/campaign_card.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/state_management/campaigns/campaign_list_notifier.dart';
import 'package:empylo_app/state_management/loading_state_notifier.dart';
import 'package:empylo_app/ui/molecules/dialogues/campaign_dialog.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaigns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignCard extends ConsumerWidget {
  const CampaignCard({Key? key}) : super(key: key);

  Future<void> handleCampaignCreation(
      BuildContext context, WidgetRef ref, Campaign campaign) async {
    ref.read(loadingStateProvider.notifier).startLoading();
    void navPop() {
      Navigator.pop(context);
    } // close the dialog

    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref
          .read(campaignListNotifierProvider.notifier)
          .createCampaign(campaign, ref);
      ref.read(loadingStateProvider.notifier).stopLoading();
      navPop(); // close the modal after successful creation
    } catch (e) {
      // Handle error gracefully, maybe with a SnackBar or dialog
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to create the campaign. Please try again.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.green[10],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Campaigns",
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CampaignDialog(
                        campaign: null,
                        onCampaignEdited: (campaign) {
                          handleCampaignCreation(context, ref, campaign);
                        },
                        type: 'create',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const Campaigns(),
        ],
      ),
    );
  }
}

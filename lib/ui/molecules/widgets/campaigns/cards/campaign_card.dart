import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignCard extends ConsumerWidget {
  const CampaignCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.green[10],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          const Text(
            "Campaigns Form",
            textAlign: TextAlign.center,
          ),
          CreateCampaignForm(
            nameController: TextEditingController(),
            authState: ref.watch(authStateProvider),
            companyIdController: TextEditingController(),
            descriptionController: TextEditingController(),
            frequencyController: TextEditingController(),
            durationController: TextEditingController(),
            startDateController: TextEditingController(),
            endDateController: TextEditingController(),
            thresholdController: TextEditingController(),
            audienceIdsController: TextEditingController(),
            questionnaireIdsController: TextEditingController(),
          ),
        ],
      ),
    );
  }
}

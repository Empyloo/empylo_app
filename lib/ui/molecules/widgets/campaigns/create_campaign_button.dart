// Path: lib/ui/molecules/widgets/campaigns/create_campaign_button.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/state_management/campaigns/campaign_list_notifier.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCampaignButton extends StatelessWidget {
  const CreateCampaignButton({
    super.key,
    required this.context,
    required this.nameController,
    required this.thresholdController,
    required this.companyIdController,
    required this.durationController,
    required this.endDateController,
    required this.frequencyController,
    required this.descriptionController,
    required this.audienceIdsController,
    required this.questionnaireIdsController,
    required this.ref,
  });

  final BuildContext context;
  final TextEditingController nameController;
  final TextEditingController thresholdController;
  final TextEditingController companyIdController;
  final TextEditingController durationController;
  final TextEditingController endDateController;
  final TextEditingController frequencyController;
  final TextEditingController descriptionController;
  final TextEditingController audienceIdsController;
  final TextEditingController questionnaireIdsController;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (nameController.text.isEmpty ||
            thresholdController.text.isEmpty ||
            companyIdController.text.isEmpty ||
            durationController.text.isEmpty ||
            endDateController.text.isEmpty ||
            frequencyController.text.isEmpty ||
            descriptionController.text.isEmpty ||
            audienceIdsController.text.isEmpty ||
            questionnaireIdsController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all the fields.'),
            ),
          );
          return;
        }
        final scaff = ScaffoldMessenger.of(context);
        final newCampaign = Campaign(
          name: nameController.text,
          count: 0,
          threshold: int.parse(thresholdController.text),
          status: '',
          companyId: companyIdController.text,
          createdBy: '',
          nextRunTime: DateTime.now(),
          id: '',
          type: '',
          duration: durationController.text,
          endDate: DateTime.parse(endDateController.text),
          frequency: frequencyController.text,
          timeOfDay: '',
          description: descriptionController.text,
          audienceIds: audienceIdsController.text.split(',').toList(),
          questionnaireIds: questionnaireIdsController.text.split(',').toList(),
          cloudTaskId: '',
        );
        final result = await ref
            .read(campaignListNotifierProvider.notifier)
            .createCampaign(newCampaign, ref);
        if (result) {
          scaff.showSnackBar(
            const SnackBar(
              content: Text('Campaign created successfully.'),
            ),
          );
        } else {
          scaff.showSnackBar(
            const SnackBar(
              content: Text('Error creating campaign.'),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorTokens.onPrimary,
        backgroundColor: ColorTokens.primaryDark,
      ),
      child: const Text('Create Campaign'),
    );
  }
}

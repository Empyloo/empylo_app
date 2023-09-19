// Path: lib/ui/molecules/dialogues/helpers/campaign_button_builder.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/utils/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignButtonBuilder {
  final TextEditingController statusController;
  final TextEditingController companyIdController;
  final TextEditingController typeController;
  final TextEditingController frequencyController;
  final TextEditingController audienceIdsController;
  final TextEditingController questionnaireIdsController;

  CampaignButtonBuilder({
    required this.statusController,
    required this.companyIdController,
    required this.typeController,
    required this.frequencyController,
    required this.audienceIdsController,
    required this.questionnaireIdsController,
  });

  String? validateFields() {
    if (statusController.text.isEmpty) return 'Status is missing.';
    if (companyIdController.text.isEmpty) return 'Select a Company.';
    if (typeController.text.isEmpty) return 'Type is missing.';
    if (frequencyController.text.isEmpty && typeController.text != 'instant') {
      return 'Frequency is missing.';
    }
    if (audienceIdsController.text.isEmpty) return 'Audience IDs are missing.';
    if (questionnaireIdsController.text.isEmpty) {
      return 'Questionnaire IDs are missing.';
    }
    return null; // Return null if no errors.
  }

  Widget buildSaveButton(
    BuildContext context,
    WidgetRef ref,
    String type,
    Campaign? campaign,
    Function(BuildContext, WidgetRef, Campaign) handleCampaignEditing,
    Function(BuildContext, WidgetRef, Campaign) handleCampaignCreation,
    TextEditingController nameController,
    TextEditingController descriptionController,
    TextEditingController countController,
    TextEditingController createdByController,
    TextEditingController startDateController,
    TextEditingController endDateController,
    TextEditingController thresholdController,
    TextEditingController timeOfDayController,
    TextEditingController durationController,
  ) {
    return ElevatedButton(
      child: Text('${type.capitalizeFirst()} Campaign'),
      onPressed: () {
        final validationError = validateFields();
        if (validationError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(validationError)),
          );
          return;
        }

        final userProfile = ref.read(userProfileNotifierProvider);
        try {
          final Campaign newCampaign = Campaign(
            id: campaign?.id,
            name: nameController.text,
            description: descriptionController.text,
            companyId: companyIdController.text,
            frequency: typeController.text == 'instant'
                ? 'once'
                : frequencyController.text,
            type: typeController.text,
            duration: durationController.text,
            nextRunTime: startDateController.text.isNotEmpty
                ? DateTime.parse(startDateController.text)
                : DateTime.now(),
            endDate: endDateController.text.isNotEmpty
                ? DateTime.parse(endDateController.text)
                : null,
            threshold: int.parse(thresholdController.text),
            // add time now if type is instant
            timeOfDay: timeOfDayController.text.isNotEmpty
                ? timeOfDayController.text
                : null,
            audienceIds: audienceIdsController.text.split(', ').toList(),
            questionnaireIds:
                questionnaireIdsController.text.split(', ').toList(),
            count: int.parse(countController.text),
            status: statusController.text,
            createdBy: createdByController.text.isEmpty
                ? userProfile!.id
                : createdByController.text,
          );
          if (type == "edit" && campaign != null) {
            handleCampaignEditing(context, ref, newCampaign);
          } else {
            handleCampaignCreation(context, ref, newCampaign);
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
          return;
        }
      },
    );
  }
}

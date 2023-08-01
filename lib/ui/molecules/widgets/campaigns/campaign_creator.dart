import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_date_picker.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_time_picker.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/duration_text_field.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/frequency_drop_down.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/styled_campaign_text_field.dart';
import 'package:empylo_app/ui/molecules/widgets/companies/company_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_campaign_button.dart';

class CreateCampaignForm extends ConsumerWidget {
  const CreateCampaignForm({
    super.key,
    required this.nameController,
    required this.authState,
    required this.companyIdController,
    required this.descriptionController,
    required this.frequencyController,
    required this.durationController,
    required this.startDateController,
    required this.endDateController,
    required this.thresholdController,
    required this.audienceIdsController,
    required this.questionnaireIdsController,
  });

  final TextEditingController nameController;
  final AuthState authState;
  final TextEditingController companyIdController;
  final TextEditingController descriptionController;
  final TextEditingController frequencyController;
  final TextEditingController durationController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController thresholdController;
  final TextEditingController audienceIdsController;
  final TextEditingController questionnaireIdsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          StyledCampaignTextField(
            controller: nameController,
            labelText: 'Campaign Name',
          ),
          if (authState.role == UserRole.superAdmin)
            CompanyMenu(
              controller: companyIdController,
            ),
          StyledCampaignTextField(
            controller: descriptionController,
            labelText: 'Description',
          ),
          FrequencyDropdown(
            controller: frequencyController,
          ),
          DurationTextField(
            controller: durationController,
          ),
          DatePickerTextField(
            controller: startDateController,
            labelText: 'Start Date',
          ),
          DatePickerTextField(
            controller: endDateController,
            labelText: 'End Date',
          ),
          StyledCampaignTextField(
            controller: thresholdController,
            labelText: 'Threshold',
          ),
          TimePickerTextField(
            controller: startDateController,
            labelText: 'Time of Day',
          ),
          StyledCampaignTextField(
            controller: audienceIdsController,
            labelText: 'Audience IDs',
          ),
          StyledCampaignTextField(
            controller: questionnaireIdsController,
            labelText: 'Questionnaire IDs',
          ),
          CreateCampaignButton(
              context: context,
              nameController: nameController,
              thresholdController: thresholdController,
              companyIdController: companyIdController,
              durationController: durationController,
              endDateController: endDateController,
              frequencyController: frequencyController,
              descriptionController: descriptionController,
              audienceIdsController: audienceIdsController,
              questionnaireIdsController: questionnaireIdsController,
              ref: ref),
        ],
      ),
    );
  }
}

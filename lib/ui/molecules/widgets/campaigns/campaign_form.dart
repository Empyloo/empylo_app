// Path: lib/ui/molecules/widgets/campaigns/campaign_form.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/campaigns/campaign_list_notifier.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_date_picker.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_time_picker.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/create_campaign_button.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/duration_text_field.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/frequency_drop_down.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/styled_campaign_text_field.dart';
import 'package:empylo_app/ui/molecules/widgets/companies/company_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignForm extends ConsumerWidget {
  const CampaignForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final nameController = TextEditingController();
    final type = TextEditingController();
    final companyIdController = TextEditingController();
    final descriptionController = TextEditingController();
    final frequencyController = TextEditingController();
    final durationController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final thresholdController = TextEditingController();
    final audienceIdsController = TextEditingController();
    final questionnaireIdsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Campaign'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

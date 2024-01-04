// Path: lib/ui/molecules/dialogues/campaign_dialog.dart
import 'package:empylo_app/models/campaign.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/campaigns/campaign_list_notifier.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/state_management/loading_state_notifier.dart';
import 'package:empylo_app/ui/molecules/dialogues/helpers/campaign_button_builder.dart';
import 'package:empylo_app/ui/molecules/inputs/labelled_drop_downs.dart';
import 'package:empylo_app/ui/molecules/widgets/audiences/audience_menu.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_date_picker.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_time_picker.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/duration_text_field.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/frequency_drop_down.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/styled_campaign_text_field.dart';
import 'package:empylo_app/ui/molecules/widgets/companies/company_selector.dart';
import 'package:empylo_app/ui/molecules/widgets/questionnaires/questionnaire_menu.dart';
import 'package:empylo_app/utils/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef CampaignCallback = Function(Campaign campaign);
final localSelectedCompanyIdProvider = StateProvider<String?>((ref) => null);
final campaignTypeProvider = StateProvider<String>((ref) => "recurring");

class CampaignDialog extends ConsumerWidget {
  final Campaign? campaign;
  final CampaignCallback onCampaignEdited;
  final String type; // "create" or "edit"

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController companyIdController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController thresholdController = TextEditingController();
  final TextEditingController timeOfDayController = TextEditingController();
  final TextEditingController audienceIdsController = TextEditingController();
  final TextEditingController questionnaireIdsController =
      TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController createdByController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  Future<void> handleCampaignCreation(
      BuildContext context, WidgetRef ref, Campaign campaign) async {
    ref.read(loadingStateProvider.notifier).startLoading();
    navPop() => Navigator.pop(context);
    final messenger = ScaffoldMessenger.of(context);
    final bool success = await ref
        .read(campaignListNotifierProvider.notifier)
        .createCampaign(campaign, ref);
    if (success) {
      navPop();
    } else {
      messenger.showSnackBar(
          const SnackBar(content: Text('Failed to create campaign.')));
      ref.read(loadingStateProvider.notifier).stopLoading();
      navPop();
    }
  }

  Future<void> handleCampaignEditing(
      BuildContext context, WidgetRef ref, Campaign campaign) async {
    ref.read(loadingStateProvider.notifier).startLoading();
    navPop() => Navigator.pop(context);
    final messenger = ScaffoldMessenger.of(context);
    final bool success = await ref
        .read(campaignListNotifierProvider.notifier)
        .updateCampaign(campaign, ref);

    if (success) {
      navPop();
    } else {
      messenger.showSnackBar(
          const SnackBar(content: Text('Failed to update campaign.')));
      navPop();
    }
    ref.read(loadingStateProvider.notifier).stopLoading();
  }

  CampaignDialog({
    super.key,
    required this.campaign,
    required this.onCampaignEdited,
    required this.type,
  }) {
    if (campaign != null) {
      nameController.text = campaign!.name;
      descriptionController.text = campaign!.description ?? '';
      companyIdController.text = campaign!.companyId;
      frequencyController.text = campaign!.frequency ?? '';
      durationController.text = campaign!.duration ?? '';
      startDateController.text = campaign!.nextRunTime.toIso8601String();
      endDateController.text = campaign!.endDate?.toIso8601String() ?? '';
      thresholdController.text = campaign!.threshold.toString();
      timeOfDayController.text = campaign!.timeOfDay ?? '';
      audienceIdsController.text = campaign!.audienceIds?.join(', ') ?? '';
      questionnaireIdsController.text =
          campaign!.questionnaireIds?.join(', ') ??
              ''; // Same assumption as above
      countController.text = campaign!.count.toString();
      statusController.text = campaign!.status;
      typeController.text = campaign!.type;
      createdByController.text = campaign!.createdBy;
      companyIdController.text = campaign!.companyId;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonBuilder = CampaignButtonBuilder(
      statusController: statusController,
      companyIdController: companyIdController,
      typeController: typeController,
      frequencyController: frequencyController,
      audienceIdsController: audienceIdsController,
      questionnaireIdsController: questionnaireIdsController,
    );
    return Dialog(
      child: Consumer(
        builder: (context, ref, child) {
          final isLoading = ref.watch(loadingStateProvider);
          return Stack(
            children: [
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('${type.capitalizeFirst()} Campaign'),
                      const Divider(thickness: 1),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              StyledCampaignTextField(
                                controller: nameController,
                                labelText: 'Campaign Name',
                              ),
                              const SizedBox(height: 8),
                              // This should only be visible if userRole is superAdmin
                              // if the userRole is admin, then the company ID should be
                              // set to the company ID of the admin
                              CompanySelector(
                                role: ref.read(authStateProvider).role,
                                companyList:
                                    ref.watch(companyListNotifierProvider),
                                isEditMode: type == 'edit',
                                onCompanySelected: (companyId) {
                                  companyIdController.text = companyId ?? '';
                                },
                                selectedCompanyId:
                                    companyIdController.text.isEmpty
                                        ? null
                                        : companyIdController.text,
                              ),
                              const SizedBox(height: 8),
                              StyledCampaignTextField(
                                controller: descriptionController,
                                labelText: 'Description',
                              ),
                              const SizedBox(height: 8),
                              StyledCampaignTextField(
                                controller: countController,
                                labelText: 'Count',
                              ),
                              const SizedBox(height: 8),
                              StyledCampaignTextField(
                                controller: thresholdController,
                                labelText: 'Threshold',
                              ),
                              const SizedBox(height: 8),
                              LabeledDropdown(
                                controller: typeController,
                                items: const ['recurring', 'instant'],
                                labelText: 'Type',
                                onChanged: (value) {
                                  ref
                                      .read(campaignTypeProvider.notifier)
                                      .state = value!;
                                },
                              ),
                              const SizedBox(height: 8),
                              LabeledDropdown(
                                controller: statusController,
                                items: const [
                                  'draft',
                                  'active',
                                  'paused',
                                  'deactivated'
                                ],
                                labelText: 'Status',
                              ),
                              const SizedBox(height: 8),
                              Consumer(
                                builder: (context, ref, child) {
                                  final campaignType =
                                      ref.watch(campaignTypeProvider);
                                  if (campaignType == "instant") {
                                    return const SizedBox
                                        .shrink();
                                  }
                                  return Column(
                                    children: [
                                      FrequencyDropdown(
                                        controller: frequencyController,
                                      ),
                                      const SizedBox(height: 8),
                                      DurationTextField(
                                        controller: durationController,
                                      ),
                                      const SizedBox(height: 8),
                                      DatePickerTextField(
                                        controller: startDateController,
                                        labelText: 'Start Date',
                                      ),
                                      const SizedBox(height: 8),
                                      DatePickerTextField(
                                        controller: endDateController,
                                        labelText: 'End Date',
                                      ),
                                      const SizedBox(height: 8),
                                      TimePickerTextField(
                                        controller: timeOfDayController,
                                        labelText: 'Time of Day',
                                      ),
                                    ],
                                  );
                                },
                              ),
                              AudienceMenu(
                                controller: audienceIdsController,
                              ),
                              const SizedBox(height: 8),
                              QuestionnaireMenu(
                                controller: questionnaireIdsController,
                              ),
                              const SizedBox(height: 8),
                              buttonBuilder.buildSaveButton(
                                context,
                                ref,
                                type,
                                campaign,
                                handleCampaignEditing,
                                handleCampaignCreation,
                                nameController,
                                descriptionController,
                                countController,
                                createdByController,
                                startDateController,
                                endDateController,
                                thresholdController,
                                timeOfDayController,
                                durationController,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

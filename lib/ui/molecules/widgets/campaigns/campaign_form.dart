// Path: lib/ui/molecules/widgets/campaigns/campaign_form.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_creator.dart';
import 'package:empylo_app/ui/pages/audience_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignForm extends ConsumerWidget {
  const CampaignForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaigns'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // If the screen width is greater than 600, we display a Row
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                child: Card(
                                  color: Colors.blue[
                                      10], // customize the color as needed
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: const Column(
                                    children: [
                                      Text(
                                        "Audiences",
                                        textAlign: TextAlign.center,
                                      ),
                                      AudiencePage(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                color: Colors.green[
                                    15], // customize the color as needed
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
                                      companyIdController:
                                          TextEditingController(),
                                      descriptionController:
                                          TextEditingController(),
                                      frequencyController:
                                          TextEditingController(),
                                      durationController:
                                          TextEditingController(),
                                      startDateController:
                                          TextEditingController(),
                                      endDateController:
                                          TextEditingController(),
                                      thresholdController:
                                          TextEditingController(),
                                      audienceIdsController:
                                          TextEditingController(),
                                      questionnaireIdsController:
                                          TextEditingController(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // If the screen width is less than or equal to 600, we display a Column
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Card(
                                color: Colors
                                    .blue[15], // customize the color as needed
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: const Column(
                                  children: [
                                    Text(
                                      "Audiences",
                                      textAlign: TextAlign.center,
                                    ),
                                    AudiencePage(),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: Colors
                                  .green[10], // customize the color as needed
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
                                    companyIdController:
                                        TextEditingController(),
                                    descriptionController:
                                        TextEditingController(),
                                    frequencyController:
                                        TextEditingController(),
                                    durationController: TextEditingController(),
                                    startDateController:
                                        TextEditingController(),
                                    endDateController: TextEditingController(),
                                    thresholdController:
                                        TextEditingController(),
                                    audienceIdsController:
                                        TextEditingController(),
                                    questionnaireIdsController:
                                        TextEditingController(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

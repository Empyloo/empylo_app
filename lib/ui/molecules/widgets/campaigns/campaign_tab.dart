// Path: lib/ui/molecules/widgets/campaigns/campaign_tab.dart
import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/state_management/audiences/audience_notifier.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/audiences/audience_modal.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/campaign_creator.dart';
import 'package:empylo_app/ui/pages/audience_page.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignTab extends ConsumerWidget {
  const CampaignTab({Key? key}) : super(key: key);

  Future<void> handleAudienceCreation(
      BuildContext context, WidgetRef ref, Audience audience) async {
    final userProfile = ref.watch(userProfileNotifierProvider);
    navPop() {
      Navigator.pop(context);
    } // close the dialog

    final accessToken = await getAccessToken(ref);
    await ref.read(audienceNotifierProvider.notifier).createAudience(
        userProfile!.id, userProfile.companyID, accessToken, audience);
    navPop(); // close the modal
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget audienceCard = Card(
      color: Colors.blue[10],
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
                  "Audiences",
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
                      builder: (context) => AudienceModal(
                        audience: null,
                        onAudienceEdited: (audience) =>
                            handleAudienceCreation(context, ref, audience),
                        type: 'create',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const AudiencePage(),
        ],
      ),
    );

    Widget campaignCard = Card(
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
                                child: audienceCard,
                              ),
                            ),
                            Expanded(
                              child: campaignCard,
                            ),
                          ],
                        );
                      } else {
                        // If the screen width is less than or equal to 600, we display a Column
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: audienceCard,
                            ),
                            campaignCard,
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

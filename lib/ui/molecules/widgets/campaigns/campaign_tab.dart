// Path: lib/ui/molecules/widgets/campaigns/campaign_tab.dart
import 'package:empylo_app/ui/molecules/widgets/campaigns/cards/audience_card.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/cards/campaign_card.dart';
import 'package:empylo_app/ui/molecules/widgets/campaigns/cards/questionnaire_card.dart';
import 'package:empylo_app/ui/molecules/widgets/questions/question_card.dart'; // import QuestionCard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampaignTab extends ConsumerWidget {
  const CampaignTab({Key? key}) : super(key: key);

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
                        return Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16.0),
                                  child: const AudienceCard(),
                                ),
                              ),
                              const Expanded(
                                child: CampaignCard(),
                              ),
                              const Expanded(
                                child: QuestionnaireCard(),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          const Divider(thickness: 1.0),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: QuestionCard(),
                              )
                            ],
                          ),
                        ]);
                      } else {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: const AudienceCard(),
                            ),
                            const CampaignCard(),
                            const QuestionnaireCard(),
                            const SizedBox(
                              width: double.infinity,
                              child: QuestionCard(),
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

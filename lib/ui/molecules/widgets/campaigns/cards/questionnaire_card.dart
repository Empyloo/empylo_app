import 'package:empylo_app/models/questionnaire.dart';
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/questionnaires/questionnaire_dialog.dart';
import 'package:empylo_app/ui/pages/questionnaire_page.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionnaireCard extends ConsumerWidget {
  const QuestionnaireCard({Key? key}) : super(key: key);

  Future<void> handleQuestionnaireCreation(
      BuildContext context, WidgetRef ref, questionnaireWithQuestions) async {
    final accessToken = await getAccessToken(ref);
    final questionare = questionnaireWithQuestions.questionnaire;
    navPop() {
      Navigator.pop(context);
    }
    await ref
        .read(questionnaireNotifierProvider.notifier)
        .createQuestionnaire(questionare, accessToken);
    navPop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
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
                  "Questionnaires",
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
                      builder: (context) => QuestionnaireDialog(
                        questionnaireWithQuestions: null,
                        onQuestionnaireCreatedOrEdited: (questionnaireWithQuestions) =>
                            handleQuestionnaireCreation(
                                context, ref, questionnaireWithQuestions),
                        type: 'create',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const QuestionnairePage(),
        ],
      ),
    );
  }
}



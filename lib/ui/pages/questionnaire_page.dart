// Path: lib/ui/pages/questionnaire_page.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/questionnaires/questionnaire_dialog.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionnairePage extends ConsumerWidget {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: () async {
        final accessToken = await getAccessToken(ref);
        final userRole = ref.watch(authStateProvider);
        final userProfile = ref.watch(userProfileNotifierProvider);
        await ref
            .read(questionnaireNotifierProvider.notifier)
            .getQuestionnaires(
                userProfile!.companyID, accessToken, userRole.role.name);
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final questionnairesWithQuestions = ref
              .watch(questionnaireNotifierProvider)
              .questionnairesWithQuestions;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: questionnairesWithQuestions?.length ?? 0,
            itemBuilder: (context, index) {
              navPop() {
                Navigator.pop(context);
              }

              final questionnaire = questionnairesWithQuestions![index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(questionnaire.questionnaire.name),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => QuestionnaireDialog(
                        questionnaireWithQuestions: questionnaire,
                        onQuestionnaireCreatedOrEdited: (editedQuestionnaire) async {
                          final accessToken = await getAccessToken(ref);
                          ref
                              .read(questionnaireNotifierProvider.notifier)
                              .updateQuestionnaire(
                                  editedQuestionnaire.questionnaire,
                                  accessToken);
                          navPop();
                        },
                        type: 'edit',
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final accessToken = await getAccessToken(ref);
                      ref
                          .read(questionnaireNotifierProvider.notifier)
                          .deleteQuestionnaire(
                              questionnaire.questionnaire.id!, accessToken);
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

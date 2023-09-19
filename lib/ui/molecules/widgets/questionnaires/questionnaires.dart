// Path: lib/ui/molecules/widgets/questionnaire/questionnaires.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/questionnaires/questionnaire_dialog.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Questionnaires extends ConsumerWidget {
  final Function(String id, String name)? onQuestionnaireSelected;

  const Questionnaires({super.key, this.onQuestionnaireSelected});

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
              final questionnaire = questionnairesWithQuestions![index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(questionnaire.questionnaire.name),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      final navPop = Navigator.of(context).pop;
                      switch (value) {
                        case 'Edit':
                          // Show Edit Dialog
                          showDialog(
                            context: context,
                            builder: (context) => QuestionnaireDialog(
                              questionnaireWithQuestions: questionnaire,
                              onQuestionnaireCreatedOrEdited:
                                  (editedQuestionnaire) async {
                                final accessToken = await getAccessToken(ref);
                                ref
                                    .read(
                                        questionnaireNotifierProvider.notifier)
                                    .updateQuestionnaire(
                                        editedQuestionnaire.questionnaire,
                                        accessToken);
                                navPop();
                              },
                              type: 'edit',
                            ),
                          );
                          break;
                        case 'Delete':
                          final accessToken = await getAccessToken(ref);
                          ref
                              .read(questionnaireNotifierProvider.notifier)
                              .deleteQuestionnaire(
                                  questionnaire.questionnaire.id!, accessToken);
                          break;
                        case 'Select':
                          if (onQuestionnaireSelected != null) {
                            onQuestionnaireSelected!(
                                questionnaire.questionnaire.id!,
                                questionnaire.questionnaire.name);
                          }
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Select',
                        child: Text('Select'),
                      ),
                    ],
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

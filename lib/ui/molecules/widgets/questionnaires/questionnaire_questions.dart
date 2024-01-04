// Path: lib/ui/molecules/widgets/questionnaires/questionnaire_questions.dart
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/state_management/questions/question_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionnaireQuestions extends ConsumerWidget {
  final String? questionnaireId;

  const QuestionnaireQuestions({super.key, this.questionnaireId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(questionnaireNotifierProvider);

    QuestionnaireWithQuestions? questionnaireWithQuestions;

    try {
      questionnaireWithQuestions = state.questionnairesWithQuestions!
          .firstWhere((q) => q.questionnaire.id == questionnaireId);
    } catch (e) {
      // Handle the scenario when no matching questionnaire is found.
      return Container(); // or any other placeholder widget
    }

    final questions = questionnaireWithQuestions.questions;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Questions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                PopupMenuButton<Question>(
                  icon: const Icon(Icons.add),
                  onSelected: (Question selectedQuestion) async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final accessToken = await getAccessToken(ref);
                    final userId = ref.read(userProfileNotifierProvider)!.id;
                    final questionnaireId =
                        questionnaireWithQuestions!.questionnaire.id!;
                    try {
                      await ref
                          .read(questionnaireNotifierProvider.notifier)
                          .addQuestionToQuestionnaire(selectedQuestion,
                              accessToken, userId, questionnaireId);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Question added successfully'),
                        ),
                      );
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Error adding question: $e'),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ref
                        .watch(questionNotifierProvider)
                        .map((Question question) {
                      return PopupMenuItem<Question>(
                        value: question,
                        child: Column(
                          children: [
                            const Divider(thickness: 1),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                question.question,
                                style: const TextStyle(fontSize: 16),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ), // Display question text in menu
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (questions.isEmpty)
              const Center(child: Text('No questions in this questionnaire')),
            for (var question in questions) ...[
              ListTile(
                title: Text(
                  question.question,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  softWrap: true,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final accessToken = await getAccessToken(ref);
                    final userId = ref.read(userProfileNotifierProvider)!.id;
                    try {
                      await ref
                          .read(questionnaireNotifierProvider.notifier)
                          .removeQuestionFromQuestionnaire(
                            question,
                            accessToken,
                            userId,
                            questionnaireWithQuestions!.questionnaire.id!,
                          );
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Question removed successfully'),
                        ),
                      );
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Error removing question: $e'),
                        ),
                      );
                    }
                  },
                ),
              ),
              const Divider(thickness: 1), // A divider between each question
            ]
          ],
        ),
      ),
    );
  }
}

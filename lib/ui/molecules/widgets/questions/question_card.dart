// Path: lib/ui/molecules/widgets/questions/question_card.dart
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/state_management/questions/question_notifier.dart';
import 'package:empylo_app/ui/molecules/widgets/questions/question_form.dart';
import 'package:empylo_app/ui/pages/questions_page.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionCard extends ConsumerWidget {
  const QuestionCard({Key? key}) : super(key: key);

  Future<void> handleQuestionCreation(
      BuildContext context, WidgetRef ref, Question question) async {
    navPop() {
      Navigator.pop(context);
    } // close the dialog

    final accessToken = await getAccessToken(ref);
    await ref
        .read(questionNotifierProvider.notifier)
        .createQuestion(accessToken, question);
    navPop(); // close the modal
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.blue[10],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Questions",
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
                      builder: (context) => QuestionForm(
                        question: null,
                        onQuestionEdited: (question) =>
                            handleQuestionCreation(context, ref, question),
                        type: 'create',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const QuestionsPage() // Wrap QuestionsPage in an Expanded widget
        ],
      ),
    );
  }
}

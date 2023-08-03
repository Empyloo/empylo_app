// Path: lib/ui/molecules/widgets/questions/question_form.dart
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:empylo_app/utils/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/state_management/questions/question_notifier.dart';

typedef QuestionCallback = Function(Question question);

class QuestionForm extends ConsumerWidget {
  final Question? question;
  final QuestionCallback onQuestionEdited;
  final String type; // "create" or "edit"

  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  QuestionForm({
    Key? key,
    required this.question,
    required this.onQuestionEdited,
    required this.type,
  }) : super(key: key) {
    if (question != null) {
      questionController.text = question!.question;
      descriptionController.text = question!.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Question ${type.capitalizeFirst()}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextFormField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (Form.of(context).validate()) {
                  final updatedQuestion = Question(
                    id: question?.id,
                    question: questionController.text,
                    description: descriptionController.text,
                    // Fill the remaining fields
                    createdBy: 'userId',
                    updatedBy: 'userId',
                    companyId: 'companyId',
                  );
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navPop = Navigator.of(context).pop;
                  try {
                    final accessToken = await getAccessToken(ref);
                    if (type == "edit") {
                      await ref
                          .read(questionNotifierProvider.notifier)
                          .updateQuestion(accessToken, updatedQuestion);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Question updated'),
                        ),
                      );
                    } else {
                      await ref
                          .read(questionNotifierProvider.notifier)
                          .createQuestion(accessToken, updatedQuestion);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Question created'),
                        ),
                      );
                    }
                    onQuestionEdited(updatedQuestion);
                    navPop();
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update question'),
                      ),
                    );
                  }
                }
              },
              child: Text('Submit ${type.capitalizeFirst()} Question'),
            ),
          ],
        ),
      ),
    );
  }
}

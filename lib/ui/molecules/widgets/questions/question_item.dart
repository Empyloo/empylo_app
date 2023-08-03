// Path: lib/ui/molecules/widgets/questions/question_item.dart
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/state_management/questions/question_notifier.dart';

class QuestionItem extends ConsumerWidget {
  final Question question;

  const QuestionItem({super.key, required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Icon(Icons.help_outline),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    question.question,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            if (question.description != null)
              Row(
                children: [
                  const Icon(Icons.description),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text('Description: ${question.description}'),
                  ),
                ],
              ),
            if (question.comment != null)
              Row(
                children: [
                  const Icon(Icons.comment),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text('Comment: ${question.comment}'),
                  ),
                ],
              ),
            if (question.approved != null)
              Row(
                children: [
                  const Icon(Icons.check_circle),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text('Approved: ${question.approved}'),
                  ),
                ],
              ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final accessToken = await getAccessToken(ref);
                    try {
                      ref
                          .read(questionNotifierProvider.notifier)
                          .updateQuestion(accessToken, question);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Question updated'),
                        ),
                      );
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Failed to update question'),
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    try {
                      ref
                          .read(questionNotifierProvider.notifier)
                          .deleteQuestion('accessToken', question.id!);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Question deleted'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to delete question'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

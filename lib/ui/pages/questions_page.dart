// Path: lib/ui/pages/questions_page.dart
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/questions/question_item.dart';
import 'package:empylo_app/state_management/questions/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionsPage extends ConsumerWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileNotifierProvider);
    final AuthState authState = ref.watch(authStateProvider);
    String accessToken = '';
    ref.watch(accessBoxProvider.future).then((accessBox) {
      accessToken = accessBox.get('session')['access_token'];
    });

    return FutureBuilder<void>(
      future: ref.read(questionNotifierProvider.notifier).fetchQuestions(
          accessToken, authState.role.name, userProfile!.companyID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load questions'));
        }
        return Consumer(
          builder: (context, ref, child) {
            final questions = ref.watch(questionNotifierProvider);
            if (questions.isEmpty) {
              return const Center(child: Text('No questions'));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return QuestionItem(question: questions[index]);
              },
            );
          },
        );
      },
    );
  }
}

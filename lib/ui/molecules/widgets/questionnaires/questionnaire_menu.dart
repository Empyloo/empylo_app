// Path: lib/ui/molecules/widgets/questionnaires/questionnaire_menu.dart
import 'package:empylo_app/models/questionnaire.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionnaireMenu extends ConsumerWidget {
  final TextEditingController controller;

  const QuestionnaireMenu({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionnaireListNotifier =
        ref.read(questionnaireNotifierProvider.notifier);
    final questionnaires = ref
            .watch(questionnaireNotifierProvider)
            .questionnairesWithQuestions
            ?.map((qwq) => qwq.questionnaire)
            .toList() ??
        [];
    final userProfile = ref.watch(userProfileNotifierProvider);
    final authState = ref.watch(authStateProvider);

    if (questionnaires.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final accessToken = await getAccessToken(ref);
        await questionnaireListNotifier.getQuestionnaires(
            userProfile!.companyID, accessToken, authState.role.name);
      });
      return const CircularProgressIndicator();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Questionnaire',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            height: 60.0,
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: controller.text.isEmpty ? null : controller.text,
              onChanged: (value) {
                controller.text = value ?? '';
              },
              items: questionnaires
                  .map<DropdownMenuItem<String>>((Questionnaire questionnaire) {
                return DropdownMenuItem<String>(
                  value: questionnaire.id,
                  child: Text(questionnaire.name),
                );
              }).toList(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              isExpanded: true,
            ),
          ),
        ],
      );
    }
  }
}

// Path: lib/ui/molecules/widgets/questionnaires/edit_or_create_questionnaire.dart
import 'package:empylo_app/models/questionnaire.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef QuestionnaireWithQuestionsCallback = Function(
    QuestionnaireWithQuestions questionnaireWithQuestions);

void editOrCreateQuestionnaire({
  required BuildContext context,
  required WidgetRef ref,
  required TextEditingController nameController,
  required TextEditingController descriptionController,
  required String type,
  required QuestionnaireWithQuestions? questionnaireWithQuestions,
  required QuestionnaireWithQuestionsCallback onQuestionnaireCreatedOrEdited,
}) async {
  final userProfile = ref.watch(userProfileNotifierProvider);
  final questionnaireName = nameController.text;
  final questionnaireDescription = descriptionController.text;

  if (questionnaireName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Please enter a name for the questionnaire.')),
    );
    return;
  }

  final updatedQuestionnaire = Questionnaire(
    id: questionnaireWithQuestions?.questionnaire.id ?? '',
    name: questionnaireName,
    description: questionnaireDescription,
    companyId: questionnaireWithQuestions?.questionnaire.companyId ??
        userProfile!.companyID,
  );

  final updatedQuestionnaireWithQuestions = QuestionnaireWithQuestions(
    questionnaire: updatedQuestionnaire,
    questions: questionnaireWithQuestions?.questions ?? [],
  );

  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
    final successMessage = type == "edit" ? "edited" : "created";
    await onQuestionnaireCreatedOrEdited(updatedQuestionnaireWithQuestions);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Questionnaire $successMessage successfully'),
      ),
    );
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Failed to $type questionnaire: $e'),
      ),
    );
  }
}

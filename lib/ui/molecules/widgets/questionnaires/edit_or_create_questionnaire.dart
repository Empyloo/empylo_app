// Path: lib/ui/molecules/widgets/questionnaires/edit_or_create_questionnaire.dart
import 'package:empylo_app/models/questionnaire.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/utils/get_company_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef QuestionnaireWithQuestionsCallback = Function(
    QuestionnaireWithQuestions questionnaireWithQuestions);

void editOrCreateQuestionnaire({
  required BuildContext context,
  required WidgetRef ref,
  required TextEditingController nameController,
  required TextEditingController descriptionController,
  required String type, // "create" or "edit"
  required QuestionnaireWithQuestions? questionnaireWithQuestions,
  required QuestionnaireWithQuestionsCallback onQuestionnaireCreatedOrEdited,
  TextEditingController? companyIdController,
}) async {
  final userProfile = ref.read(userProfileNotifierProvider);
  final questionnaireName = nameController.text.trim();
  final questionnaireDescription = descriptionController.text.trim();
  final accessToken =
      ref.watch(accessBoxProvider).value?.get('session')['access_token'];
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // Basic Validation
  if (questionnaireName.isEmpty) {
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Please enter a name for the questionnaire.'),
      ),
    );
    return;
  }

  final companyId = getCompanyId(
    companyIdController: companyIdController?.text.trim(),
    questionnaireWithQuestions: questionnaireWithQuestions,
    userProfile: userProfile!,
  );

  final updatedQuestionnaire = Questionnaire(
    id: questionnaireWithQuestions?.questionnaire.id,
    name: questionnaireName,
    description: questionnaireDescription,
    companyId: companyId,
  );

  final updatedQuestionnaireWithQuestions = QuestionnaireWithQuestions(
    questionnaire: updatedQuestionnaire,
    questions: questionnaireWithQuestions?.questions ?? [],
  );

  try {
    if (type == "edit") {
      await ref
          .read(questionnaireNotifierProvider.notifier)
          .updateQuestionnaire(updatedQuestionnaire, accessToken);
    } else {
      await ref
          .read(questionnaireNotifierProvider.notifier)
          .createQuestionnaire(updatedQuestionnaire, accessToken);
    }

    onQuestionnaireCreatedOrEdited(updatedQuestionnaireWithQuestions);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
            'Questionnaire ${type == "edit" ? "edited" : "created"} successfully'),
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

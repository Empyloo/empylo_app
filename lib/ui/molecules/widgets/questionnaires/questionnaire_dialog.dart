// Path: lib/ui/widgets/questionnaire_dialog.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/ui/molecules/widgets/companies/company_selector.dart';
import 'package:empylo_app/ui/molecules/widgets/questionnaires/questionnaire_questions.dart';
import 'package:empylo_app/utils/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/ui/molecules/widgets/questionnaires/edit_or_create_questionnaire.dart';

typedef QuestionnaireWithQuestionsCallback = Function(
    QuestionnaireWithQuestions questionnaireWithQuestions);

class QuestionnaireDialog extends ConsumerWidget {
  final QuestionnaireWithQuestions? questionnaireWithQuestions;
  final QuestionnaireWithQuestionsCallback onQuestionnaireCreatedOrEdited;
  final String type; // "create" or "edit"

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController companyIdController = TextEditingController();

  QuestionnaireDialog({
    super.key,
    required this.questionnaireWithQuestions,
    required this.onQuestionnaireCreatedOrEdited,
    required this.type,
  }) {
    if (questionnaireWithQuestions != null) {
      nameController.text = questionnaireWithQuestions!.questionnaire.name;
      descriptionController.text =
          questionnaireWithQuestions!.questionnaire.description ?? '';
      companyIdController.text = questionnaireWithQuestions!
          .questionnaire.companyId
          .toString(); // assuming companyId is int
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${type.capitalizeFirst()} Questionnaire'),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (ref.watch(authStateProvider).role.name == "superAdmin")
                  TextField(
                    controller: companyIdController,
                    decoration: const InputDecoration(
                      labelText: 'Company ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                const SizedBox(height: 16),
                if (ref.watch(authStateProvider).role.name == "superAdmin")
                  CompanySelector(
                    role: ref.watch(authStateProvider).role,
                    companyList: ref.watch(companyListNotifierProvider),
                    isEditMode: type == "edit",
                    onCompanySelected: (companyId) {
                      companyIdController.text = companyId ?? '';
                    },
                    selectedCompanyId:
                        questionnaireWithQuestions?.questionnaire.companyId,
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: Text('${type.capitalizeFirst()} Questionnaire'),
                  onPressed: () {
                    editOrCreateQuestionnaire(
                      context: context,
                      ref: ref,
                      nameController: nameController,
                      descriptionController: descriptionController,
                      companyIdController: companyIdController,
                      type: type,
                      questionnaireWithQuestions: questionnaireWithQuestions,
                      onQuestionnaireCreatedOrEdited:
                          onQuestionnaireCreatedOrEdited,
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 16),
                QuestionnaireQuestions(
                  questionnaireId: questionnaireWithQuestions?.questionnaire.id,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Path: lib/ui/widgets/questionnaire_dialog.dart
import 'package:empylo_app/state_management/questionnaires/questionnaire_state.dart';
import 'package:empylo_app/utils/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/ui/molecules/widgets/questionnaires/edit_or_create_questionnaire.dart'; // import the function here

typedef QuestionnaireWithQuestionsCallback = Function(
    QuestionnaireWithQuestions questionnaireWithQuestions);

class QuestionnaireDialog extends ConsumerWidget {
  final QuestionnaireWithQuestions? questionnaireWithQuestions;
  final QuestionnaireWithQuestionsCallback onQuestionnaireCreatedOrEdited;
  final String type; // "create" or "edit"

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  QuestionnaireDialog({
    Key? key,
    required this.questionnaireWithQuestions,
    required this.onQuestionnaireCreatedOrEdited,
    required this.type,
  }) : super(key: key) {
    if (questionnaireWithQuestions != null) {
      nameController.text = questionnaireWithQuestions!.questionnaire.name;
      descriptionController.text =
          questionnaireWithQuestions!.questionnaire.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: SizedBox(
        width: 400,
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
              ElevatedButton(
                child: Text('${type.capitalizeFirst()} Questionnaire'),
                onPressed: () {
                  editOrCreateQuestionnaire(
                    context: context,
                    ref: ref,
                    nameController: nameController,
                    descriptionController: descriptionController,
                    type: type,
                    questionnaireWithQuestions: questionnaireWithQuestions,
                    onQuestionnaireCreatedOrEdited: onQuestionnaireCreatedOrEdited,
                  );
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

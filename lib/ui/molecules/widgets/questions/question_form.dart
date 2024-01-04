// Path: lib/ui/molecules/widgets/questions/question_form.dart
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/state_management/questions/question_form_state.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/companies/company_selector.dart';
import 'package:empylo_app/ui/molecules/widgets/field_contatiner.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/state_management/questions/question_notifier.dart';

final hasChangesProvider = StateProvider<bool>((ref) => false);

enum FormType {
  create,
  edit,
}

typedef QuestionCallback = Function(Question question);

class QuestionForm extends ConsumerWidget {
  final Question? question;
  final QuestionCallback onQuestionCreateOrEdited;
  final FormType formType;

  final TextEditingController questionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController createdByController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  QuestionForm({
    super.key,
    required this.question,
    required this.onQuestionCreateOrEdited,
    required this.formType,
  }) {
    if (question != null) {
      questionController.text = question!.question;
      descriptionController.text = question!.description ?? '';
      commentController.text = question!.comment ?? '';
      createdByController.text = question!.createdBy;
    }
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final userProfile = ref.watch(userProfileNotifierProvider);
      final authState = ref.watch(authStateProvider);
      final formState = ref.watch(questionFormProvider);
      final updatedQuestion = Question(
        id: question?.id,
        question: questionController.text,
        description: descriptionController.text,
        comment: commentController.text,
        approved: formState.isApproved ?? question?.approved ?? false,
        createdBy: userProfile!.id,
        updatedBy: userProfile.id,
        companyId: formState.selectedCompanyId ??
            question?.companyId ??
            createdByController.text,
      );
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      void popNavigator() {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }

      try {
        final accessToken = await getAccessToken(ref);
        if (formType == FormType.edit) {
          await ref
              .read(questionNotifierProvider.notifier)
              .updateQuestion(accessToken, updatedQuestion);
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Question updated'),
            ),
          );
          popNavigator();
        } else {
          onQuestionCreateOrEdited(updatedQuestion);
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Question created'),
            ),
          );
          popNavigator();
        }
      } catch (e) {
        popNavigator();
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Failed to update question'),
          ),
        );
        popNavigator();
      }
    }
  }

  void markAsChanged(WidgetRef ref) {
    ref.read(hasChangesProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() {
      ref.read(selectedCompanyIdProvider.notifier).state = null;
      if (question != null &&
          ref.watch(questionFormProvider).isApproved == null) {
        ref
            .read(questionFormProvider.notifier)
            .setIsApproved(question!.approved);
      }
    });
    final authState = ref.watch(authStateProvider);
    final companyList = ref.watch(companyListNotifierProvider);

    if (companyList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ref.read(selectedCompanyIdProvider.notifier).state = null;
        await ref
            .read(companyListNotifierProvider.notifier)
            .fetchCompanies(ref);
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('${formType == FormType.edit ? 'Edit' : 'Create'} Question',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              buildFieldContainer(
                child: TextFormField(
                  controller: questionController,
                  onChanged: (_) => markAsChanged(ref),
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
              ),
              buildFieldContainer(
                child: TextFormField(
                  controller: descriptionController,
                  onChanged: (_) => markAsChanged(ref),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              buildFieldContainer(
                child: TextFormField(
                  controller: commentController,
                  onChanged: (_) => markAsChanged(ref),
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    border: InputBorder.none,
                  ),
                ),
              ),
              buildFieldContainer(
                child: Row(
                  children: [
                    const Text('Approved'),
                    Radio<bool?>(
                        value: true,
                        groupValue: ref.watch(questionFormProvider).isApproved,
                        onChanged: (value) {
                          ref.read(questionFormProvider.notifier).setIsApproved(
                                value,
                              );
                          markAsChanged(ref);
                        }),
                    const Text('Yes'),
                    Radio<bool?>(
                      value: false,
                      groupValue: ref.watch(questionFormProvider).isApproved,
                      onChanged: (value) {
                        ref
                            .read(questionFormProvider.notifier)
                            .setIsApproved(value);
                        markAsChanged(ref);
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ),
              CompanySelector(
                role: authState.role,
                companyList: companyList,
                isEditMode: formType == FormType.edit,
                onCompanySelected: (companyId) {
                  ref
                      .read(questionFormProvider.notifier)
                      .setSelectedCompanyId(companyId);
                  markAsChanged(ref);
                },
                selectedCompanyId: question?.companyId,
              ),
              const SizedBox(height: 16),
              if (ref.watch(hasChangesProvider))
                const Text('You have unsaved changes. Submit to save them.'),
              ElevatedButton(
                onPressed: ref.watch(hasChangesProvider)
                    ? () => _submit(context, ref)
                    : null,
                child: Text(
                    'Submit ${formType == FormType.edit ? 'Edit' : 'Create'} Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

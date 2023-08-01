// Path: lib/state_management/questionnaire_form_state.dart
import 'package:empylo_app/models/questionnaire.dart';
import 'package:empylo_app/state_management/questionnaire_service_provider.dart';
import 'package:empylo_app/state_management/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum QuestionnaireFormStatus { initial, loading, success, error }

class QuestionnaireFormState {
  final Questionnaire? questionnaire;
  final QuestionnaireFormStatus status;
  final String errorMessage;

  QuestionnaireFormState({
    this.questionnaire,
    required this.status,
    this.errorMessage = '',
  });

  QuestionnaireFormState copyWith({
    Questionnaire? questionnaire,
    QuestionnaireFormStatus? status,
    String? errorMessage,
  }) {
    return QuestionnaireFormState(
      questionnaire: questionnaire ?? this.questionnaire,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class QuestionnaireFormNotifier extends StateNotifier<QuestionnaireFormState> {
  final WidgetRef _ref;

  QuestionnaireFormNotifier(this._ref)
      : super(QuestionnaireFormState(status: QuestionnaireFormStatus.initial));

  Future createQuestionnaire(Questionnaire questionnaire) async {
    state = state.copyWith(status: QuestionnaireFormStatus.loading);
    try {
      final questionnaireService = _ref.read(questionnaireServiceProvider);
      final session = _ref.watch(sessionProvider);

      final createdQuestionnaire =
          await questionnaireService.createQuestionnaire(
        session!.accessToken,
        questionnaire,
      );
      state = state.copyWith(
          questionnaire: createdQuestionnaire,
          status: QuestionnaireFormStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireFormStatus.error,
          errorMessage: 'Failed to create questionnaire');
    }
  }

  Future updateQuestionnaire(Questionnaire questionnaire) async {
    state = state.copyWith(status: QuestionnaireFormStatus.loading);
    try {
      final questionnaireService = _ref.read(questionnaireServiceProvider);
      final session = _ref.watch(sessionProvider);

      final updatedQuestionnaire =
          await questionnaireService.updateQuestionnaire(
        session!.accessToken,
        questionnaire.id!,
        questionnaire.toJson(),
      );
      state = state.copyWith(
          questionnaire: updatedQuestionnaire,
          status: QuestionnaireFormStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireFormStatus.error,
          errorMessage: 'Failed to update questionnaire');
    }
  }

  Future deleteQuestionnaire(String id) async {
    state = state.copyWith(status: QuestionnaireFormStatus.loading);
    try {
      final questionnaireService = _ref.read(questionnaireServiceProvider);
      final session = _ref.watch(sessionProvider);

      await questionnaireService.deleteQuestionnaire(session!.accessToken, id);
      state = state.copyWith(
          questionnaire: null, status: QuestionnaireFormStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireFormStatus.error,
          errorMessage: 'Failed to delete questionnaire');
    }
  }
}

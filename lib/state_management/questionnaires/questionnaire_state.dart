import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/models/questionnaire.dart';
import 'package:empylo_app/services/question_service.dart';
import 'package:empylo_app/services/questionnaire_service.dart';
import 'package:empylo_app/state_management/questionnaire_service_provider.dart';
import 'package:empylo_app/state_management/questions/question_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum QuestionnaireStateStatus { initial, loading, success, error }

class QuestionnaireWithQuestions {
  final Questionnaire questionnaire;
  final List<Question> questions;

  QuestionnaireWithQuestions(
      {required this.questionnaire, required this.questions});

  QuestionnaireWithQuestions copyWith({
    Questionnaire? questionnaire,
    List<Question>? questions,
  }) {
    return QuestionnaireWithQuestions(
      questionnaire: questionnaire ?? this.questionnaire,
      questions: questions ?? this.questions,
    );
  }
}

class QuestionnaireState {
  final List<QuestionnaireWithQuestions>? questionnairesWithQuestions;
  final QuestionnaireStateStatus status;
  final String errorMessage;

  QuestionnaireState({
    this.questionnairesWithQuestions,
    required this.status,
    this.errorMessage = '',
  });

  QuestionnaireState copyWith({
    List<QuestionnaireWithQuestions>? questionnairesWithQuestions,
    QuestionnaireStateStatus? status,
    String? errorMessage,
  }) {
    return QuestionnaireState(
      questionnairesWithQuestions:
          questionnairesWithQuestions ?? this.questionnairesWithQuestions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  final QuestionnaireService _questionnaireService;
  final QuestionService _questionService;

  QuestionnaireNotifier(this._questionnaireService, this._questionService)
      : super(QuestionnaireState(status: QuestionnaireStateStatus.initial));

  Future createQuestionnaire(
      Questionnaire questionnaire, String accessToken) async {
    state = state.copyWith(status: QuestionnaireStateStatus.loading);
    try {
      final createdQuestionnaire =
          await _questionnaireService.createQuestionnaire(
        accessToken,
        questionnaire,
      );
      state = state.copyWith(questionnairesWithQuestions: [
        QuestionnaireWithQuestions(
            questionnaire: createdQuestionnaire, questions: [])
      ], status: QuestionnaireStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireStateStatus.error,
          errorMessage: 'Failed to create questionnaire');
    }
  }

  Future updateQuestionnaire(
      Questionnaire questionnaire, String accessToken) async {
    state = state.copyWith(status: QuestionnaireStateStatus.loading);
    try {
      final updatedQuestionnaire =
          await _questionnaireService.updateQuestionnaire(
        accessToken,
        questionnaire.id!,
        questionnaire.toJson(),
      );
      final updatedQuestionnairesWithQuestions = state
          .questionnairesWithQuestions!
          .map((q) => q.questionnaire.id == updatedQuestionnaire.id
              ? q.copyWith(questionnaire: updatedQuestionnaire)
              : q)
          .toList();
      state = state.copyWith(
          questionnairesWithQuestions: updatedQuestionnairesWithQuestions,
          status: QuestionnaireStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireStateStatus.error,
          errorMessage: 'Failed to update questionnaire');
    }
  }

  Future deleteQuestionnaire(String id, String accessToken) async {
    state = state.copyWith(status: QuestionnaireStateStatus.loading);
    try {
      await _questionnaireService.deleteQuestionnaire(accessToken, id);
      final updatedQuestionnairesWithQuestions = state
          .questionnairesWithQuestions!
          .where((q) => q.questionnaire.id != id)
          .toList();
      state = state.copyWith(
          questionnairesWithQuestions: updatedQuestionnairesWithQuestions,
          status: QuestionnaireStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireStateStatus.error,
          errorMessage: 'Failed to delete questionnaire');
    }
  }

  // get quesionnaires
  Future getQuestionnaires(
      String companyId, String accessToken, String role) async {
    state = state.copyWith(status: QuestionnaireStateStatus.loading);
    try {
      final questionnaires = await _questionnaireService.getQuestionnaires(
        companyId,
        accessToken,
        role,
      );

      // Create an empty list to store the QuestionnaireWithQuestions objects.
      List<QuestionnaireWithQuestions> questionnairesWithQuestions = [];

      // For each questionnaire, get the associated questions and
      // create a QuestionnaireWithQuestions object.
      for (var q in questionnaires) {
        final questions = await _questionService.getQuestionsInQuestionnaire(
          q.id!,
          accessToken,
        );
        questionnairesWithQuestions.add(
            QuestionnaireWithQuestions(questionnaire: q, questions: questions));
      }

      state = state.copyWith(
          questionnairesWithQuestions: questionnairesWithQuestions,
          status: QuestionnaireStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireStateStatus.error,
          errorMessage: 'Failed to get questionnaires');
    }
  }

  Future removeQuestionFromQuestionnaire(Question question, String accessToken,
      String userId, String questionnaireId) async {
    state = state.copyWith(status: QuestionnaireStateStatus.loading);
    try {
      await _questionService.removeQuestionFromQuestionnaire(
        accessToken,
        question.id!,
        questionnaireId,
        userId,
      );
      final updatedQuestionnairesWithQuestions = state
          .questionnairesWithQuestions!
          .map((q) => q.questionnaire.id == questionnaireId
              ? q.copyWith(
                  questions:
                      q.questions.where((q) => q.id != question.id).toList())
              : q)
          .toList();
      state = state.copyWith(
          questionnairesWithQuestions: updatedQuestionnairesWithQuestions,
          status: QuestionnaireStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireStateStatus.error,
          errorMessage: 'Failed to remove question from questionnaire');
      rethrow;
    }
  }

  Future addQuestionToQuestionnaire(Question question, String accessToken,
      String userId, String questionnaireId) async {
    state = state.copyWith(status: QuestionnaireStateStatus.loading);
    try {
      await _questionService.addQuestionToQuestionnaire(
        accessToken,
        question.id!,
        questionnaireId,
        userId,
      );
      final updatedQuestionnairesWithQuestions = state
          .questionnairesWithQuestions!
          .map((q) => q.questionnaire.id == questionnaireId
              ? q.copyWith(questions: [...q.questions, question])
              : q)
          .toList();
      state = state.copyWith(
          questionnairesWithQuestions: updatedQuestionnairesWithQuestions,
          status: QuestionnaireStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireStateStatus.error,
          errorMessage: 'Failed to add question to questionnaire');
      rethrow;
    }
  }

  Future<List<Question>> getQuestionsForQuestionnaire(
      String questionnaireId, String accessToken) async {
    state = state.copyWith(status: QuestionnaireStateStatus.loading);
    try {
      final questions = await _questionService.getQuestionsInQuestionnaire(
        accessToken,
        questionnaireId,
      );
      final updatedQuestionnairesWithQuestions = state
          .questionnairesWithQuestions!
          .map((q) => q.questionnaire.id == questionnaireId
              ? q.copyWith(questions: questions)
              : q)
          .toList();
      state = state.copyWith(
          questionnairesWithQuestions: updatedQuestionnairesWithQuestions,
          status: QuestionnaireStateStatus.success);
      return questions;
    } catch (e) {
      state = state.copyWith(
          status: QuestionnaireStateStatus.error,
          errorMessage: 'Failed to get questions for questionnaire');
      rethrow;
    }
  }
}

final questionnaireNotifierProvider =
    StateNotifierProvider<QuestionnaireNotifier, QuestionnaireState>((ref) {
  final questionnaireService = ref.watch(questionnaireServiceProvider);
  final questionService = ref.watch(questionServiceProvider);
  return QuestionnaireNotifier(questionnaireService, questionService);
});

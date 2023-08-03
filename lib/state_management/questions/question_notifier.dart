// Path: lib/state_management/questions/question_notifier.dart
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/services/question_service.dart';
import 'package:empylo_app/state_management/questions/question_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionNotifier extends StateNotifier<List<Question>> {
  final QuestionService _questionService;

  QuestionNotifier(this._questionService) : super([]);

  Future<void> fetchQuestions(
      String accessToken, String userRole, String companyId) async {
    state =
        await _questionService.getQuestions(accessToken, userRole, companyId);
  }

  Future<void> createQuestion(String accessToken, Question question) async {
    final createdQuestion =
        await _questionService.createQuestion(accessToken, question);
    state = [...state, createdQuestion];
  }

  Future<void> deleteQuestion(String accessToken, String questionId) async {
    await _questionService.deleteQuestion(accessToken, questionId: questionId);
    state = state.where((question) => question.id != questionId).toList();
  }

  Future<void> updateQuestion(String accessToken, Question question) async {
    final updatedQuestion = await _questionService.updateQuestion(
        accessToken, question.id!, question.toJson());
    state = state
        .map((q) => q.id == updatedQuestion.id ? updatedQuestion : q)
        .toList();
  }

  Future<void> addQuestionToQuestionnaire(
    String accessToken,
    String questionId,
    String questionnaireId,
    String userId,
  ) async {
    await _questionService.addQuestionToQuestionnaire(
        accessToken, questionId, questionnaireId, userId);
  }

  Future<void> removeQuestionFromQuestionnaire(
    String accessToken,
    String questionId,
    String questionnaireId,
    String userId,
  ) async {
    await _questionService.removeQuestionFromQuestionnaire(
        accessToken, questionId, questionnaireId, userId);
  }
}

final questionNotifierProvider =
    StateNotifierProvider<QuestionNotifier, List<Question>>((ref) {
  final questionService = ref.watch(questionServiceProvider);
  return QuestionNotifier(questionService);
});

// Path: lib/state_management/questions/questionnaire_questions_notifier.dart
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/services/question_service.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionnaireQuestionsServiceProvider = Provider<QuestionService>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  return QuestionService(
    sentry: sentry,
    http: httpClient,
  );
});

final questionnaireQuestionsNotifierProvider =
    StateNotifierProvider<QuestionnaireQuestionsNotifier, List<Question>>(
        (ref) {
  final questionService = ref.read(questionnaireQuestionsServiceProvider);
  return QuestionnaireQuestionsNotifier(questionService);
});

class QuestionnaireQuestionsNotifier extends StateNotifier<List<Question>> {
  final QuestionService _questionService;

  QuestionnaireQuestionsNotifier(this._questionService) : super([]);

  Future<List<Question>> getQuestionsInQuestionnaire(
      String questionnaireId, String accessToken) async {
    try {
      final questionnaireQuestions = await _questionService
          .getQuestionsInQuestionnaire(questionnaireId, accessToken);
      state = questionnaireQuestions;
      return questionnaireQuestions;
    } catch (e) {
      throw Exception('Error fetching questions in questionnaire: $e');
    }
  }

  Future<void> addQuestionToQuestionnaire(
      Question question, String accessToken, String userId) async {
    try {
      await _questionService.addQuestionToQuestionnaire(
          accessToken, question.id!, state.first.id!, userId);
      state = [...state, question];
    } catch (e) {
      throw Exception('Error adding question to questionnaire: $e');
    }
  }

  Future<void> removeQuestionFromQuestionnaire(
      Question question, String accessToken, String userId) async {
    try {
      await _questionService.removeQuestionFromQuestionnaire(
          accessToken, question.id!, state.first.id!, userId);
      state = state.where((q) => q.id != question.id).toList();
    } catch (e) {
      throw Exception('Error removing question from questionnaire: $e');
    }
  }

  void clearQuestions() {
    state = [];
  }
}

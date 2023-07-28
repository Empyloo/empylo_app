// Path: lib/state_management/survey/survey_notifier.dart
import 'package:empylo_app/models/answer.dart';
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/services/survey_service.dart';
import 'package:empylo_app/state_management/survey/survey_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final surveyProvider =
    StateNotifierProvider<SurveyNotifier, SurveyState>((ref) {
  final surveyService = ref.read(surveyServiceProvider);
  return SurveyNotifier(surveyService: surveyService);
});

class SurveyState {
  final List<Question> questions;
  final List<Answer> answers;
  final bool isLoading;

  SurveyState(
      {required this.questions, required this.answers, this.isLoading = false});

  SurveyState copyWith({
    List<Question>? questions,
    List<Answer>? answers,
    bool? isLoading,
  }) {
    return SurveyState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SurveyNotifier extends StateNotifier<SurveyState> {
  final SurveyService _surveyService;

  SurveyNotifier({required SurveyService surveyService})
      : _surveyService = surveyService,
        super(SurveyState(questions: [], answers: []));

  Future<void> loadQuestions(String surveyId, String accessToken) async {
    state = state.copyWith(isLoading: true);
    try {
      // Load the survey questions from the service
      final questions =
          await _surveyService.getQuestions(surveyId, accessToken);
      state = state.copyWith(questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Here you might want to handle the error, e.g. logging it or showing an error message
      rethrow;
    }
  }

  void answerQuestion(String questionId, dynamic answer) {
    // Update the user's answer for a specific question
    void updateAnswer(String questionId, dynamic answer) {
      final index = int.parse(questionId);
      state.answers[index] = answer;
      state = state.copyWith(answers: state.answers);
    }

    state.answers[int.parse(questionId)] = answer;
    state = state.copyWith(answers: state.answers);
  }

  Future<void> submitAnswers(String surveyId) async {
    state = state.copyWith(isLoading: true);
    try {
      // Submit the user's answers to the service
      await _surveyService.submitAnswers(surveyId, state.answers);
      // Clear the answers after successful submission
      state = state.copyWith(answers: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Here you might want to handle the error, e.g. logging it or showing an error message
      rethrow;
    }
  }
}

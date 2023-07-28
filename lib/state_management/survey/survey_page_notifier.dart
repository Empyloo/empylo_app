// Path: lib/state_management/survey/survey_page_notifier.dart
import 'package:empylo_app/models/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyPageState {
  final int currentQuestionIndex;
  final List<Question> questions;

  SurveyPageState(
      {required this.currentQuestionIndex, required this.questions});

  SurveyPageState copyWith(
      {int? currentQuestionIndex, List<Question>? questions}) {
    return SurveyPageState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      questions: questions ?? this.questions,
    );
  }
}

class SurveyPageNotifier extends StateNotifier<SurveyPageState> {
  SurveyPageNotifier()
      : super(SurveyPageState(currentQuestionIndex: 0, questions: []));

  void goToNextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state =
          state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    }
  }

  void goToPreviousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state =
          state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1);
    }
  }
}

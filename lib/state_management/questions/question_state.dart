import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/services/question_service.dart';
import 'package:empylo_app/state_management/questions/question_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum QuestionStateStatus { initial, loading, success, error }

class QuestionState {
  final Question? question;
  final QuestionStateStatus status;
  final String errorMessage;

  QuestionState({
    this.question,
    required this.status,
    this.errorMessage = '',
  });

  QuestionState copyWith({
    Question? question,
    QuestionStateStatus? status,
    String? errorMessage,
  }) {
    return QuestionState(
      question: question ?? this.question,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class QuestionNotifier extends StateNotifier<QuestionState> {
  final QuestionService _questionService;

  QuestionNotifier(this._questionService)
      : super(QuestionState(status: QuestionStateStatus.initial));

  Future createQuestion(Question question, String accessToken) async {
    state = state.copyWith(status: QuestionStateStatus.loading);
    try {
      final createdQuestion = await _questionService.createQuestion(
        accessToken,
        question,
      );
      state = state.copyWith(
          question: createdQuestion, status: QuestionStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionStateStatus.error,
          errorMessage: 'Failed to create question');
    }
  }

  Future updateQuestion(Question question, String accessToken) async {
    state = state.copyWith(status: QuestionStateStatus.loading);
    try {
      final updatedQuestion = await _questionService.updateQuestion(
        accessToken,
        question.id!,
        question.toJson(),
      );
      state = state.copyWith(
          question: updatedQuestion, status: QuestionStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionStateStatus.error,
          errorMessage: 'Failed to update question');
    }
  }

  Future deleteQuestion(String id, String accessToken) async {
    state = state.copyWith(status: QuestionStateStatus.loading);
    try {
      await _questionService.deleteQuestion(accessToken, questionId: id);
      state =
          state.copyWith(question: null, status: QuestionStateStatus.success);
    } catch (e) {
      state = state.copyWith(
          status: QuestionStateStatus.error,
          errorMessage: 'Failed to delete question');
    }
  }
}

final questionNotifierProvider =
    StateNotifierProvider<QuestionNotifier, QuestionState>((ref) {
  final questionService = ref.watch(questionServiceProvider);
  return QuestionNotifier(questionService);
});

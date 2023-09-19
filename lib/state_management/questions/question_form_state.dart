// Path: lib/state_management/questions/question_form_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionFormState extends StateNotifier<QuestionFormModel> {
  QuestionFormState() : super(QuestionFormModel());

  void setIsApproved(bool? value) => state = state.copyWith(isApproved: value);

  void setSelectedCompanyId(String? value) =>
      state = state.copyWith(selectedCompanyId: value);
    
  void reset() => state = QuestionFormModel();
}

final questionFormProvider =
    StateNotifierProvider<QuestionFormState, QuestionFormModel>((ref) {
  return QuestionFormState();
});

class QuestionFormModel {
  final bool? isApproved;
  final String? selectedCompanyId;

  QuestionFormModel({
    this.isApproved,
    this.selectedCompanyId,
  });

  QuestionFormModel copyWith({
    bool? isApproved,
    String? selectedCompanyId,
  }) {
    return QuestionFormModel(
      isApproved: isApproved ?? this.isApproved,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
    );
  }
}

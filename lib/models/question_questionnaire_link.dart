// Path: lib/models/question_questionnaire_link.dart

class QuestionQuestionnaireLink {
  final String questionId;
  final String questionnaireId;
  final String? createdBy;
  final String? editedBy;
  final DateTime? createdAt;
  final DateTime? editedAt;

  const QuestionQuestionnaireLink({
    required this.questionId,
    required this.questionnaireId,
    this.createdBy,
    this.editedBy,
    this.createdAt,
    this.editedAt,
  });

  factory QuestionQuestionnaireLink.fromJson(Map<String, dynamic> json) {
    return QuestionQuestionnaireLink(
      questionId: json['question_id'],
      questionnaireId: json['questionnaire_id'],
      createdBy: json['created_by'],
      editedBy: json['edited_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      editedAt:
          json['edited_at'] != null ? DateTime.parse(json['edited_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'questionnaire_id': questionnaireId,
      'created_by': createdBy,
      'edited_by': editedBy,
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'edited_at':
          editedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  QuestionQuestionnaireLink copyWith({
    String? questionId,
    String? questionnaireId,
    String? createdBy,
    String? editedBy,
    DateTime? createdAt,
    DateTime? editedAt,
  }) {
    return QuestionQuestionnaireLink(
      questionId: questionId ?? this.questionId,
      questionnaireId: questionnaireId ?? this.questionnaireId,
      createdBy: createdBy ?? this.createdBy,
      editedBy: editedBy ?? this.editedBy,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
    );
  }
}

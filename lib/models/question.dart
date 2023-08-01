// Path: lib/models/question.dart
class Question {
  final String? id;
  final String question;
  final String? description;
  final Map<String, dynamic>? data;
  final String? comment;
  final String createdBy;
  final String updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? approved;
  final String companyId;

  Question({
    this.id,
    required this.question,
    this.description,
    this.data,
    this.comment,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.approved,
    required this.companyId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      description: json['description'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      comment: json['comment'] as String?,
      createdBy: json['created_by'] as String,
      updatedBy: json['updated_by'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      approved: json['approved'] as bool?,
      companyId: json['company_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'description': description,
      'data': data,
      'comment': comment,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'company_id': companyId,
      if (approved != null) 'approved': approved,
    };
  }
}

class Answer {
  final String? id;
  final String? textAnswer;
  final double? floatAnswer;
  final bool? booleanAnswer;
  final String? comment;
  final Duration? durationToAnswer;
  final Map<String, dynamic>? data;
  final String? campaignId;
  final String questionId;
  late String? userId;
  final String createdBy;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Answer({
    this.id,
    this.textAnswer,
    this.floatAnswer,
    this.booleanAnswer,
    this.comment,
    this.durationToAnswer,
    this.data,
    this.campaignId,
    this.userId,
    required this.questionId,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as String,
      textAnswer: json['text_answer'] as String?,
      floatAnswer: json['float_answer'] as double?,
      booleanAnswer: json['boolean_answer'] as bool?,
      comment: json['comment'] as String?,
      durationToAnswer: json['duration_to_answer'] != null
          ? Duration(milliseconds: json['duration_to_answer'])
          : null,
      data: json['data'] as Map<String, dynamic>?,
      campaignId: json['campaign_id'] as String?,
      questionId: json['question_id'] as String,
      userId: json['user_id'] as String,
      createdBy: json['created_by'] as String,
      updatedBy: json['updated_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text_answer': textAnswer,
      'float_answer': floatAnswer,
      'boolean_answer': booleanAnswer,
      'comment': comment,
      'duration_to_answer': durationToAnswer?.inMilliseconds,
      'data': data,
      'campaign_id': campaignId,
      'question_id': questionId,
      'user_id': userId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

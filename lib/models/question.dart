class Question {
  final String id;
  final String question;
  final String? description;
  final Map<String, dynamic>? data;

  Question({
    required this.id,
    required this.question,
    this.description,
    this.data,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      description: json['description'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}

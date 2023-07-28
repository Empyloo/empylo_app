import 'package:empylo_app/models/question.dart';

class Survey {
  final String id;
  final String title;
  final List<Question> questions;

  Survey({required this.id, required this.title, required this.questions});

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'] as String,
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

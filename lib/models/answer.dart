class Answer {
  final String id;
  final String? textAnswer;
  final double? floatAnswer;
  final bool? booleanAnswer;
  final String? comment;
  final int? durationToAnswer;
  final Map<String, dynamic>? data;

  Answer({
    required this.id,
    this.textAnswer,
    this.floatAnswer,
    this.booleanAnswer,
    this.comment,
    this.durationToAnswer,
    this.data,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as String,
      textAnswer: json['textAnswer'] as String?,
      floatAnswer: json['floatAnswer'] as double?,
      booleanAnswer: json['booleanAnswer'] as bool?,
      comment: json['comment'] as String?,
      durationToAnswer: json['durationToAnswer'] as int?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'textAnswer': textAnswer,
      'floatAnswer': floatAnswer,
      'booleanAnswer': booleanAnswer,
      'comment': comment,
      'durationToAnswer': durationToAnswer,
      'data': data,
    };
  }
}

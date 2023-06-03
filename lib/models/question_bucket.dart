// Path: lib/models/question_bucket.dart
class QuestionBucket {
  final String? id;
  final String name;
  final String? description;
  final Map<String, dynamic>? data;
  final String companyId;
  final String createdBy;
  final String updatedBy;

  QuestionBucket({
    this.id,
    required this.name,
    this.description,
    this.data,
    required this.companyId,
    required this.createdBy,
    required this.updatedBy,
  });

  factory QuestionBucket.fromJson(Map<String, dynamic> json) {
    return QuestionBucket(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      companyId: json['company_id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'description': description,
      'data': data,
      'company_id': companyId,
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }

  QuestionBucket copyWith(Map<String, dynamic> updates) {
    return QuestionBucket(
      id: updates['id'] ?? id,
      name: updates['name'] ?? name,
      description: updates['description'] ?? description,
      data: updates['data'] ?? data,
      companyId: updates['company_id'] ?? companyId,
      createdBy: updates['created_by'] ?? createdBy,
      updatedBy: updates['updated_by'] ?? updatedBy,
    );
  }
}

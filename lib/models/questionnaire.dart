// Path: lib/models/questionnaire.dart

class Questionnaire {
  final String? id;
  final String name;
  final String? description;
  final String? createdBy;
  final String? editedBy;
  final DateTime? createdAt;
  final DateTime? editedAt;
  final int? count;
  final String companyId;

  const Questionnaire({
    this.id,
    required this.name,
    this.description,
    this.createdBy,
    this.editedBy,
    this.createdAt,
    this.editedAt,
    this.count,
    required this.companyId,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return Questionnaire(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['created_by'],
      editedBy: json['edited_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      editedAt:
          json['edited_at'] != null ? DateTime.parse(json['edited_at']) : null,
      count: json['count'],
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'created_by': createdBy,
      'edited_by': editedBy,
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'edited_at':
          editedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'count': count,
      'company_id': companyId,
    };
  }

  Questionnaire copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    String? editedBy,
    DateTime? createdAt,
    DateTime? editedAt,
    int? count,
    String? companyId,
  }) {
    return Questionnaire(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      editedBy: editedBy ?? this.editedBy,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      count: count ?? this.count,
      companyId: companyId ?? this.companyId,
    );
  }
}

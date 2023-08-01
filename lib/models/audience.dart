class Audience {
  final String id;
  final String name;
  final String? description;
  final int? count;
  final String type;
  final String? createdBy;
  final String? editedBy;
  final DateTime createdAt;
  final String? companyId;

  Audience({
    required this.id,
    required this.name,
    this.description,
    this.count,
    required this.type,
    this.createdBy,
    this.editedBy,
    required this.createdAt,
    this.companyId,
  });

  factory Audience.fromJson(Map<String, dynamic> json) {
    return Audience(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      count: json['count'],
      type: json['type'],
      createdBy: json['created_by'],
      editedBy: json['edited_by'],
      createdAt: DateTime.parse(json['created_at']),
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'count': count,
      'type': type,
      'created_by': createdBy,
      'edited_by': editedBy,
      'created_at': createdAt.toIso8601String(),
      'company_id': companyId,
    };
  }
}

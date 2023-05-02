// Path: lib/models/team.dart
class Team {
  final String id;
  final String name;
  final String? description;
  final String? logo;
  final Map<String, dynamic>? data;
  final String? parentId;
  final int level;
  final String? levelName;
  final String companyId;
  bool selected;

  Team(
      {required this.id,
      required this.name,
      this.description,
      this.logo,
      this.data,
      this.parentId,
      required this.level,
      this.levelName,
      required this.companyId,
      this.selected = false});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        logo: json['logo'],
        data: json['data'],
        parentId: json['parent_id'],
        level: json['level'],
        levelName: json['level_name'],
        companyId: json['company_id'],
        selected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'data': data,
      'parent_id': parentId,
      'level': level,
      'level_name': levelName,
      'company_id': companyId,
    };
  }

  copyWith({required bool selected}) {}
}

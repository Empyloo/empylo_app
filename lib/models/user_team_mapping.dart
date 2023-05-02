class UserTeamMapping {
  final String userId;
  final String teamId;
  final String companyId;

  UserTeamMapping(
      {required this.userId, required this.teamId, required this.companyId});

  factory UserTeamMapping.fromJson(Map<String, dynamic> json) {
    return UserTeamMapping(
      userId: json['user_id'],
      teamId: json['team_id'],
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'team_id': teamId,
      'company_id': companyId,
    };
  }
}

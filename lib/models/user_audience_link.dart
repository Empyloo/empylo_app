// Path: lib/models/user_audience_link.dart
class UserAudienceLink {
  final String userId;
  final String audienceId;
  final String? createdBy;
  final String? editedBy;

  UserAudienceLink({
    required this.userId,
    required this.audienceId,
    this.createdBy,
    this.editedBy,
  });

  factory UserAudienceLink.fromJson(Map<String, dynamic> json) {
    return UserAudienceLink(
      userId: json['user_id'],
      audienceId: json['audience_id'],
      createdBy: json['created_by'],
      editedBy: json['edited_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'audience_id': audienceId,
      'created_by': createdBy,
      'edited_by': editedBy,
    };
  }
}

class AudienceMember {
  final String audienceId;
  final String email;

  AudienceMember({
    required this.audienceId,
    required this.email,
  });

  factory AudienceMember.fromJson(Map<String, dynamic> json) {
    return AudienceMember(
      audienceId: json['audience_id'],
      email: json['email'],
    );
  }
}

// Path: lib/models/user_profile.dart
class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final Map<String, dynamic>? data;
  final String? jobTitle;
  final String? gender;
  final bool? married;
  final String? ethnicity;
  final String? sexuality;
  final bool? disability;
  final String? ageRange;
  final String profileStatus;
  final bool? isParent;
  final bool? teamSelected;
  final bool? acceptedTerms;
  final String? profileType;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.data,
    this.jobTitle,
    this.gender,
    this.married,
    this.ethnicity,
    this.sexuality,
    this.disability,
    this.ageRange,
    required this.profileStatus,
    this.isParent,
    this.teamSelected,
    this.acceptedTerms,
    this.profileType,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      data: json['data'],
      jobTitle: json['job_title'],
      gender: json['gender'],
      married: json['married'],
      ethnicity: json['ethnicity'],
      sexuality: json['sexuality'],
      disability: json['disability'],
      ageRange: json['age_range'],
      profileStatus: json['profile_status'],
      isParent: json['is_parent'],
      teamSelected: json['team_selected'],
      acceptedTerms: json['accepted_terms'],
      profileType: json['profile_type'],
    );
  }

  UserProfile fromMap(Map<String, dynamic> updates) {
    return UserProfile(
      id: updates['id'] ?? id,
      firstName: updates['first_name'] ?? firstName,
      lastName: updates['last_name'] ?? lastName,
      email: updates['email'] ?? email,
      phone: updates['phone'] ?? phone,
      data: updates['data'] ?? data,
      jobTitle: updates['job_title'] ?? jobTitle,
      gender: updates['gender'] ?? gender,
      married: updates['married'] ?? married,
      ethnicity: updates['ethnicity'] ?? ethnicity,
      sexuality: updates['sexuality'] ?? sexuality,
      disability: updates['disability'] ?? disability,
      ageRange: updates['age_range'] ?? ageRange,
      profileStatus: updates['profile_status'] ?? profileStatus,
      isParent: updates['is_parent'] ?? isParent,
      teamSelected: updates['team_selected'] ?? teamSelected,
      acceptedTerms: updates['accepted_terms'] ?? acceptedTerms,
      profileType: updates['profile_type'] ?? profileType,
    );
  }

  UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    Map<String, dynamic>? data,
    String? jobTitle,
    String? gender,
    bool? married,
    String? ethnicity,
    String? sexuality,
    bool? disability,
    String? ageRange,
    String? profileStatus,
    bool? isParent,
    bool? teamSelected,
    bool? acceptedTerms,
    String? profileType,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      data: data ?? this.data,
      jobTitle: jobTitle ?? this.jobTitle,
      gender: gender ?? this.gender,
      married: married ?? this.married,
      ethnicity: ethnicity ?? this.ethnicity,
      sexuality: sexuality ?? this.sexuality,
      disability: disability ?? this.disability,
      ageRange: ageRange ?? this.ageRange,
      profileStatus: profileStatus ?? this.profileStatus,
      isParent: isParent ?? this.isParent,
      teamSelected: teamSelected ?? this.teamSelected,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      profileType: profileType ?? this.profileType,
    );
  }
}

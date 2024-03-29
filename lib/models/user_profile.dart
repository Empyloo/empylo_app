// Path: lib/models/user_profile.dart
class UserProfile {
  final String id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final Map<String, dynamic>? data;
  final String? jobTitle;
  final String companyID;
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
    this.firstName,
    this.lastName,
    required this.email,
    this.phone,
    this.data,
    this.jobTitle,
    required this.companyID,
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
      companyID: json['company_id'],
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
      companyID: updates['company_id'] ?? companyID,
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

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'job_title': jobTitle,
      'company_id': companyID,
      'age_range': ageRange,
      'ethnicity': ethnicity,
      'sexuality': sexuality,
      'disability': disability,
      'married': married,
      'is_parent': isParent,
      'team_selected': teamSelected,
      'accepted_terms': acceptedTerms,
    };
  }

  UserProfile copyWith(Map<String, dynamic> updates) {
    return UserProfile(
      id: updates['id'] ?? id,
      firstName: updates['first_name'] ?? firstName,
      lastName: updates['last_name'] ?? lastName,
      email: updates['email'] ?? email,
      phone: updates['phone'] ?? phone,
      data: updates['data'] ?? data,
      jobTitle: updates['job_title'] ?? jobTitle,
      companyID: updates['company_id'] ?? companyID,
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
}

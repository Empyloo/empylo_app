class UserProfile {
  final String id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final dynamic data;
  final String? jobTitle;
  final String? gender;
  final bool? married;
  final String? ethnicity;
  final String? sexuality;
  final String? disability;
  final String? dateOfBirth;
  final String? profileStatus;
  final bool? isParent;
  final bool? teamSelected;
  final bool? acceptedTerms;
  final String? profileType;
  final String? companyId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? startDate;

  UserProfile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.data,
      required this.jobTitle,
      required this.gender,
      required this.married,
      required this.ethnicity,
      required this.sexuality,
      required this.disability,
      required this.dateOfBirth,
      required this.profileStatus,
      required this.isParent,
      required this.teamSelected,
      required this.acceptedTerms,
      required this.profileType,
      required this.companyId,
      required this.createdAt,
      required this.updatedAt,
      required this.startDate});

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
        dateOfBirth: json['date_of_birth'],
        profileStatus: json['profile_status'],
        isParent: json['is_parent'],
        teamSelected: json['team_selected'],
        acceptedTerms: json['accepted_terms'],
        profileType: json['profile_type'],
        companyId: json['company_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        startDate: json['start_date']);
  }
}

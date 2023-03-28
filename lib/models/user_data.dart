// Path: lib/models/user_data.dart
class User {
  String? id;
  String? aud;
  String? role;
  String? email;
  String? emailConfirmedAt;
  String? phone;
  String? confirmationSentAt;
  String? confirmedAt;
  String? lastSignInAt;
  Map<String, dynamic>? appMetadata;
  Map<String, dynamic>? userMetadata;
  List<Identity>? identities;
  String? createdAt;
  String? updatedAt;
  List<Factor>? factors;

  User({
    this.id,
    this.aud,
    this.role,
    this.email,
    this.emailConfirmedAt,
    this.phone,
    this.confirmationSentAt,
    this.confirmedAt,
    this.lastSignInAt,
    this.appMetadata,
    this.userMetadata,
    this.identities,
    this.createdAt,
    this.updatedAt,
    this.factors,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var list = json['identities'] as List;
    List<Identity> identitiesList =
        list.map((i) => Identity.fromJson(i)).toList();
    List<Factor> factorsList = json['factors'];
    return User(
      id: json['id'],
      aud: json['aud'],
      role: json['role'],
      email: json['email'],
      emailConfirmedAt: json['email_confirmed_at'],
      phone: json['phone'],
      confirmationSentAt: json['confirmation_sent_at'],
      confirmedAt: json['confirmed_at'],
      lastSignInAt: json['last_sign_in_at'],
      appMetadata: json['app_metadata'],
      userMetadata: json['user_metadata'],
      identities: identitiesList,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      factors: factorsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aud': aud,
      'role': role,
      'email': email,
      'email_confirmed_at': emailConfirmedAt,
      'phone': phone,
      'confirmation_sent_at': confirmationSentAt,
      'confirmed_at': confirmedAt,
      'last_sign_in_at': lastSignInAt,
      'app_metadata': appMetadata,
      'user_metadata': userMetadata,
      'identities': identities,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'factors': factors,
    };
  }
}

class Identity {
  String? id;
  String? userId;
  Map<String, dynamic>? identityData;
  String? provider;
  String? lastSignInAt;
  String? createdAt;
  String? updatedAt;

  Identity({
    this.id,
    this.userId,
    this.identityData,
    this.provider,
    this.lastSignInAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      id: json['id'],
      userId: json['user_id'],
      identityData: json['identity_data'],
      provider: json['provider'],
      lastSignInAt: json['last_sign_in_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'identity_data': identityData,
      'provider': provider,
      'last_sign_in_at': lastSignInAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Factor {
  String id;
  String createdAt;
  String updatedAt;
  String status;
  String factorType;

  Factor({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.factorType,
  });

  factory Factor.fromJson(Map<String, dynamic> json) {
    return Factor(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      factorType: json['factor_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'factor_type': factorType,
    };
  }
}

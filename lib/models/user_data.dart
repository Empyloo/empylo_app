class User {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String refreshToken;
  final UserData userData;

  User({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
    required this.userData,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      refreshToken: json['refresh_token'],
      userData: UserData.fromJson(json['user']),
    );
  }
}



class UserData {
  String id;
  String aud;
  String role;
  String email;
  String emailConfirmedAt;
  String phone;
  String? confirmationSentAt;
  String confirmedAt;
  String lastSignInAt;
  Map<String, dynamic> appMetadata;
  Map<String, dynamic> userMetadata;
  List<Identity> identities;
  String createdAt;
  String updatedAt;

  UserData({
    required this.id,
    required this.aud,
    required this.role,
    required this.email,
    required this.emailConfirmedAt,
    required this.phone,
    required this.confirmationSentAt,
    required this.confirmedAt,
    required this.lastSignInAt,
    required this.appMetadata,
    required this.userMetadata,
    required this.identities,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    var list = json['identities'] as List;
    List<Identity> identitiesList =
        list.map((i) => Identity.fromJson(i)).toList();

    return UserData(
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
    );
  }
}

class Identity {
  String id;
  String userId;
  Map<String, dynamic> identityData;
  String provider;
  String lastSignInAt;
  String createdAt;
  String updatedAt;

  Identity({
    required this.id,
    required this.userId,
    required this.identityData,
    required this.provider,
    required this.lastSignInAt,
    required this.createdAt,
    required this.updatedAt,
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
}

import 'package:empylo_app/models/user_data.dart';

class Session {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String refreshToken;
  final User user;

  Session({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
    required this.user,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      refreshToken: json['refresh_token'],
      user: User.fromJson(json['user']),
    );
  }
}

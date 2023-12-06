class UrlParameters {
  final String accessToken;
  final String expiresAt;
  final String expiresIn;
  final String refreshToken;
  final String tokenType;
  final String type;

  UrlParameters({
    required this.accessToken,
    required this.expiresAt,
    required this.expiresIn,
    required this.refreshToken,
    required this.tokenType,
    required this.type,
  });

  factory UrlParameters.fromMap(Map<String, String> map) {
    return UrlParameters(
      accessToken: map['access_token']!,
      expiresAt: map['expires_at']!,
      expiresIn: map['expires_in']!,
      refreshToken: map['refresh_token']!,
      tokenType: map['token_type']!,
      type: map['type']!,
    );
  }
}

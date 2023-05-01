class RedirectParams {
  String accessToken;
  String expiresIn;
  String refreshToken;
  String tokenType;
  String type;

  RedirectParams({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
    required this.tokenType,
    required this.type,
  });

  factory RedirectParams.fromJson(Map<String, dynamic> json) {
    return RedirectParams(
      accessToken: json['access_token'] as String,
      expiresIn: json['expires_in'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresIn': expiresIn,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'type': type,
    };
  }

}

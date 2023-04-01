// Path: lib/utils/get_query_params.dart
Map<String, String> extractTokensFromUrl() {
  final queryParams = Uri.base.queryParameters;
  final accessToken = queryParams['access_token'];
  final refreshToken = queryParams['refresh_token'];

  Map<String, String> tokens = {};

  if (accessToken != null) {
    tokens['access_token'] = accessToken;
  }

  if (refreshToken != null) {
    tokens['refresh_token'] = refreshToken;
  }

  return tokens;
}


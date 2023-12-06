// Path: lib/constants/endpoints.dart
class Endpoints {
  static const String invitesUrl = 'https://app.empylo.com/api/v1/invite-users';
  static const String baseUrl = 'https://mdoqpekatfmlszddjwji.supabase.co';
  // companies
  static const String companiesUrl = '$baseUrl/rest/v1/companies';
  // users
  static const String usersUrl = '$baseUrl/rest/v1/users';
  // answers
  static const String answersUrl = '$baseUrl/rest/v1/answers';
  // questions
  static const String questionsUrl = '$baseUrl/rest/v1/questions';
  // auth
  static const String authUrl = '$baseUrl/auth/v1/token';
  static const String loginUrl = '$authUrl?grant_type=password';
  static const String logoutUrl = '$baseUrl/auth/v1/logout';
  static const String refreshTokenUrl = '$authUrl?grant_type=refresh_token';
  static const String validateTokenUrl = '$authUrl/validate';
  // sentry
}

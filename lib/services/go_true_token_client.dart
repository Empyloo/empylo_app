// Path: lib/services/go_true_token_client.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';

class GoTrueClient {
  // The base URL of your GoTrue server
  final String baseUrl;

  // The instance of your HttpClient
  final HttpClient httpClient;

  // The constructor that takes the base URL and the HttpClient as arguments
  GoTrueClient(this.baseUrl, this.httpClient);

  // A method that extracts the token from the URI
  String extractToken(String uri) {
    final parsedUri = Uri.parse(uri);
    return parsedUri.fragment.split('=')[1];
  }

  // A method that exchanges a refresh token for a new access token
  Future<String> refreshToken(String refreshToken) async {
    // Make a GET request to /token endpoint with refresh_token parameter using your HttpClient
    final response = await httpClient.get(
      url: '$baseUrl/token',
      queryParameters: {'refresh_token': refreshToken},
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the response data as JSON and get the access_token field
      final data = jsonDecode(response.data);
      return data['access_token'];
    } else {
      // Throw an exception if the response is not successful
      throw Exception('Failed to refresh token: ${response.data}');
    }
  }

  // A method that validates an access token by getting the user details
  Future<bool> validateToken(String accessToken) async {
    // Make a GET request to /user endpoint with Authorization header using your HttpClient
    final response = await httpClient.get(
      url: '$baseUrl/user',
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the response data as JSON and get the user object
      final data = jsonDecode(response.data);
      final user = data['user'];

      // Return true if the user object is not null and has an id field
      return user != null && user['id'] != null;
    } else {
      // Return false if the response is not successful or has an error message
      return false;
    }
  }
}

void main() {
  var sentryKey = '3c590eaf5e55481ab572190cf4119b65';
  var projectId = '6751717';
  var remoteBaseUrl = 'https://fzfsoqhwjvaymlwbcppi.supabase.co';
  var remoteAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6ZnNvcWh3anZheW1sd2JjcHBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjQ3MzA0MTksImV4cCI6MTk4MDMwNjQxOX0.AGE2xVNKAY64g8tX2r53ksJRumzRBV7Y7LZvFeWBxzk';
  // Create an instance of your HttpClient
  final sentry = SentryService(
    dio: Dio(),
    sentryKey: sentryKey,
    projectId: projectId,
  );
  final httpClient = HttpClient(
    dio: Dio(),
    sentry: sentry,
  );


  // Create an instance of the GoTrueClient
  final goTrueClient = GoTrueClient(
    // Pass the base URL of your GoTrue server
    'https://fzfsoqhwjvaymlwbcppi.supabase.co/auth/v1',
    // Pass the instance of your HttpClient
    httpClient,
  );

  // A sample URI that contains a token in the fragment part
  const uri =
      'https://example.com/#access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhdXRoIiwiZXhwIjoxNjM4NzQwMDAwLCJzdWIiOiIxMjM0NTY3ODkwIn0.8d9w4qRQO7fZm3MIHhDlZpVivq8QqE2t-4rPI6hYgBk';

  // Extract the token from the URI using the extractToken method
  final token = goTrueClient.extractToken(uri);

  // Print the token
  print(token);
}

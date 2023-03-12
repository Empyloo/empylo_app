// Path: lib/state_management/http_client_provider.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var remoteBaseUrl = 'https://fzfsoqhwjvaymlwbcppi.supabase.co';
var remoteAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6ZnNvcWh3anZheW1sd2JjcHBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjQ3MzA0MTksImV4cCI6MTk4MDMwNjQxOX0.AGE2xVNKAY64g8tX2r53ksJRumzRBV7Y7LZvFeWBxzk';

// Create an instance of your HttpClient
final httpClientProvider = Provider<HttpClient>(
  (ref) => HttpClient(
    dio: Dio(),
    sentry: ref.watch(sentryServiceProvider),
    baseUrl: remoteBaseUrl,
    anonKey: remoteAnonKey,
    headers: {'Content-Type': 'application/json'},
  ),
);

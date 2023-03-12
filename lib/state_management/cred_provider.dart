// Path: lib/state_management/cred_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';


var remoteBaseUrl = 'https://fzfsoqhwjvaymlwbcppi.supabase.co';
var remoteAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6ZnNvcWh3anZheW1sd2JjcHBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjQ3MzA0MTksImV4cCI6MTk4MDMwNjQxOX0.AGE2xVNKAY64g8tX2r53ksJRumzRBV7Y7LZvFeWBxzk';

final remoteBaseUrlProvider = Provider<String>((ref) => remoteBaseUrl);
final remoteAnonKeyProvider = Provider<String>((ref) => remoteAnonKey);
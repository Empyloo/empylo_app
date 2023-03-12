import 'package:empylo_app/services/mfa_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mfaServiceProvider = Provider<MFAService>((ref) {
  final accessToken = 'your_access_token_here';
  final baseUrl = 'https://your_project_name.supabase.co';
  return MFAService(accessToken: accessToken, baseUrl: baseUrl);
});

// final mfaServiceProvider = Provider<MFAService>((ref) {
//   final httpClient = ref.watch(httpClientProvider);
//   final baseUrl = 'https://<project-ref>.supabase.co/rest/v1/auth/factors';
//   return MFAService(httpClient: httpClient, baseUrl: baseUrl);
// });

// Path: lib/state_management/mfa_service_provider.dart
import 'package:empylo_app/services/mfa_service.dart';
import 'package:empylo_app/state_management/cred_provider.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mfaServiceProvider = Provider<MFAService>((ref) {
  return MFAService(
    baseUrl: ref.read(remoteBaseUrlProvider),
    httpClient: ref.read(httpClientProvider),
    sentry: ref.read(sentryServiceProvider),
  );
});

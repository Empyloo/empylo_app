// Path: lib/state_management/campaign_service_provider.dart
import 'package:empylo_app/services/campaign_service.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final campaignsServiceProvider = Provider<CampaignsService>((ref) {
  final httpClient = ref.read(httpClientProvider);
  final sentryService = ref.read(sentryServiceProvider);
  return CampaignsService(httpClient: httpClient, sentry: sentryService);
});

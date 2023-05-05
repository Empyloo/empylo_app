// Path: lib/state_management/company_service_provider.dart
import 'package:empylo_app/services/company_service.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final companyServiceProvider = Provider<CompanyService>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final sentryService = ref.watch(sentryServiceProvider);

  return CompanyService(client: httpClient, sentry: sentryService);
});

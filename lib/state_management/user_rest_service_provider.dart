// Path: lib/state_management/user_rest_service_provider.dart
import 'package:empylo_app/services/user_rest_service.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRestServiceProvider = Provider<UserRestService>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  return UserRestService(client: httpClient, sentry: sentry);
});

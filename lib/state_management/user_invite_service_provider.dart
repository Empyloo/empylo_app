// Path: lib/state_management/user_invite_service_provider.dart
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/user_invite_service.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userInviteServiceProvider = Provider<UserInviteService>((ref) {
  final HttpClient httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  return UserInviteService(httpClient: httpClient, sentry: sentry);
});

// Path: lib/state_management/user_provider.dart
import 'package:empylo_app/state_management/cred_provider.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:empylo_app/state_management/user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserState>>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  final anonKeyProvider = ref.read(remoteAnonKeyProvider);
  return UserNotifier(httpClient, sentry, anonKeyProvider);
});

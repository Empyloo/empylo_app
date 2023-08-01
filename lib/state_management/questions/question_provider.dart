// Path: lib/state_management/questions/question_provider.dart
import 'package:empylo_app/services/question_service.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionServiceProvider = Provider<QuestionService>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  return QuestionService(
    sentry: sentry,
    http: httpClient,
  );
});

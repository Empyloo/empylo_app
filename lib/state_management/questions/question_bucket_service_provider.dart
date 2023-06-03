// Path: lib/state_management/question_bucket_service_provider.dart
import 'package:empylo_app/services/question_bucket_service.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionBucketServiceProvider = Provider<QuestionBucketService>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  return QuestionBucketService(client: httpClient, sentry: sentry);
});

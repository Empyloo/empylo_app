// Path: lib/state_management/survey_service_provider.dart
import 'package:empylo_app/services/survey_service.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final surveyServiceProvider = Provider<SurveyService>((ref) {
  final httpClient = ref.read(httpClientProvider);
  final sentryService = ref.read(sentryServiceProvider);
  return SurveyService(client: httpClient, sentry: sentryService);
});

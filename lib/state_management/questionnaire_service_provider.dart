// Path: lib/state_management/questionnaire_service_provider.dart
import 'package:empylo_app/models/questionnaire.dart';
import 'package:empylo_app/services/questionnaire_service.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:empylo_app/state_management/session_provider.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionnaireProvider =
    FutureProvider.autoDispose<List<Questionnaire>>((ref) async {
  final questionnaireService = ref.watch(questionnaireServiceProvider);
  final session = ref.watch(sessionProvider);
  final authState = ref.watch(authStateProvider);
  final userProfile = ref.watch(userProfileNotifierProvider);
  return await questionnaireService.getQuestionnaires(
    userProfile!.companyID,
    session!.accessToken,
    authState.role.name,
    
    
  );
});

final questionnaireServiceProvider = Provider<QuestionnaireService>((ref) {
  return QuestionnaireService(
    sentry: ref.watch(sentryServiceProvider),
    http: ref.watch(httpClientProvider),
  );
});

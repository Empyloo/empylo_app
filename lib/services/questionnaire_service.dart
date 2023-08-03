// Path: lib/services/questionnaire_service.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/questionnaire.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/utils/role_based_url.dart';

class QuestionnaireService {
  final SentryService _sentry;
  final HttpClient _http;

  QuestionnaireService({
    required SentryService sentry,
    required HttpClient http,
  })  : _sentry = sentry,
        _http = http;

  Future<List<Questionnaire>> getQuestionnaires(
      String companyId, String accessToken, String userRole,
      {String? questionnaireId}) async {
    try {
      final filter = getRoleBasedFilter(userRole, companyId);
      final url =
          '$remoteBaseUrl/rest/v1/questionnaires${questionnaireId != null ? '?id=eq.$questionnaireId$filter' : '$filter'}';
      final response = await _http.get(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = response.data as List<dynamic>;
      final questionnaires = data
          .map((json) => Questionnaire.fromJson(json as Map<String, dynamic>))
          .toList();
      return questionnaires;
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching questionnaires',
          level: 'error',
          extra: {
            'context': 'QuestionnaireService.getQuestionnaires',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<Questionnaire> createQuestionnaire(
      String accessToken, Questionnaire questionnaire) async {
    try {
      print(questionnaire.toJson());
      final response = await _http.post(
        url: '$remoteBaseUrl/rest/v1/questionnaires',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: questionnaire.toJson(),
      );
      return Questionnaire.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error creating questionnaire',
          level: 'error',
          extra: {
            'context': 'QuestionnaireService.createQuestionnaire',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<Questionnaire> updateQuestionnaire(
      String accessToken, String id, Map<String, dynamic> data) async {
    try {
      final response = await _http.patch(
        url: '$remoteBaseUrl/rest/v1/questionnaires?id=eq.$id',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: data,
      );
      return Questionnaire.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error updating questionnaire',
          level: 'error',
          extra: {
            'context': 'QuestionnaireService.updateQuestionnaire',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteQuestionnaire(String accessToken, String id) async {
    try {
      await _http.delete(
        url: '$remoteBaseUrl/rest/v1/questionnaires?id=eq.$id',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error deleting questionnaire',
          level: 'error',
          extra: {
            'context': 'QuestionnaireService.deleteQuestionnaire',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }
}

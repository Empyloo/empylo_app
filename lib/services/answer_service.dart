// Path: lib/services/answer_service.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/answer.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/utils/role_based_url.dart';

class AnswerService {
  final SentryService _sentry;
  final HttpClient _http;

  AnswerService({
    required SentryService sentry,
    required HttpClient http,
  })  : _sentry = sentry,
        _http = http;

  Future<Answer> createAnswer(
      String accessToken, Answer answer, String userRole) async {
    try {
      if (userRole != 'user') {
        throw Exception('Unauthorized');
      }
      final response = await _http.post(
        url: '$remoteBaseUrl/rest/v1/answers',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: answer.toJson(),
      );
      return Answer.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error creating answer',
          level: 'error',
          extra: {
            'context': 'AnswerService.createAnswer',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<List<Answer>> getAnswers(
      String accessToken, String userRole, String companyId) async {
    try {
      final url = getRoleBasedUrl(userRole, companyId, 'rest/v1/answers');
      final response = await _http.get(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = response.data as List<dynamic>;
      final answers = data
          .map((json) => Answer.fromJson(json as Map<String, dynamic>))
          .toList();
      if (userRole != 'superAdmin') {
        for (var answer in answers) {
          answer.userId = null;
        }
      }
      return answers;
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching answers',
          level: 'error',
          extra: {
            'context': 'AnswerService.getAnswers',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<Answer> updateAnswer(
      String accessToken, String answerId, Map<String, dynamic> data) async {
    try {
      final response = await _http.patch(
        url: '$remoteBaseUrl/rest/v1/answers?id=eq.$answerId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: data,
      );
      return Answer.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error updating answer',
          level: 'error',
          extra: {
            'context': 'AnswerService.updateAnswer',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteAnswer(String accessToken, String answerId) async {
    try {
      final url = '$remoteBaseUrl/rest/v1/answers?id=eq.$answerId';
      await _http.delete(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error deleting answer',
          level: 'error',
          extra: {
            'context': 'AnswerService.deleteAnswer',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }
}

// Path: lib/services/question_service.dart
import 'dart:convert';
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/utils/role_based_url.dart';

class QuestionService {
  final SentryService _sentry;
  final HttpClient _http;

  QuestionService({
    required SentryService sentry,
    required HttpClient http,
  })  : _sentry = sentry,
        _http = http;

  Future<void> createQuestionsWithQuestionnaireId(String accessToken,
      List<Question> questions, String questionnaireId, String userId) async {
    try {
      await _http.post(
        url:
            '$remoteBaseUrl/rest/v1/rpc/insert_questions_and_link_to_questionnaire',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: jsonEncode({
          'questions': questions.map((q) => q.toJson()).toList(),
          'questionnaire_id': questionnaireId,
          'created_by': userId,
          'updated_by': userId,
        }),
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error creating questions and linking to questionnaire',
          level: 'error',
          extra: {
            'context': 'QuestionService.createQuestionsWithQuestionnaireId',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<List<Question>> getQuestions(
      String accessToken, String userRole, String companyId,
      {String? questionId}) async {
    try {
      final filter = getRoleBasedFilter(userRole, companyId);
      final url =
          '$remoteBaseUrl/rest/v1/questions${questionId != null ? '?id=eq.$questionId$filter' : filter}';
      final response = await _http.get(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = response.data as List<dynamic>;
      final questions = data
          .map((json) => Question.fromJson(json as Map<String, dynamic>))
          .toList();
      return questions;
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching questions',
          level: 'error',
          extra: {
            'context': 'QuestionService.getQuestions',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteQuestion(String accessToken,
      {String? questionId, Map<String, dynamic>? filters}) async {
    try {
      String filterQuery = '';
      if (questionId != null) {
        filterQuery = '?id=eq.$questionId';
      } else if (filters != null) {
        for (var element in filters.entries) {
          filterQuery +=
              '?${Uri.encodeComponent(element.key)}=eq.${Uri.encodeComponent(element.value)}';
        }
      }
      final url = '$remoteBaseUrl/rest/v1/questions$filterQuery';
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
          message: 'Error deleting question',
          level: 'error',
          extra: {
            'context': 'QuestionService.deleteQuestion',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<Question> updateQuestion(
      String accessToken, String questionId, Map<String, dynamic> data) async {
    try {
      final response = await _http.patch(
        url: '$remoteBaseUrl/rest/v1/questions?id=eq.$questionId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: data,
      );
      return Question.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error updating question',
          level: 'error',
          extra: {
            'context': 'QuestionService.updateQuestion',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<Question> createQuestion(String accessToken, Question question) async {
    try {
      final response = await _http.post(
        url: '$remoteBaseUrl/rest/v1/questions',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: question.toJson(),
      );
      return Question.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error creating question',
          level: 'error',
          extra: {
            'context': 'QuestionService.createQuestion',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  // add question to questionnaire  (link)
  Future<void> addQuestionToQuestionnaire(
    String accessToken,
    String questionId,
    String questionnaireId,
    String userId,
  ) async {
    try {
      await _http.post(
        url: '$remoteBaseUrl/rest/v1/question_questionnaire_link',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          'question_id': questionId,
          'questionnaire_id': questionnaireId,
          'created_by': userId,
          'updated_by': userId,
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error adding question to questionnaire',
          level: 'error',
          extra: {
            'context': 'QuestionService.addQuestionToQuestionnaire',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  // remove question from questionnaire (unlink)
  Future<void> removeQuestionFromQuestionnaire(
    String accessToken,
    String questionId,
    String questionnaireId,
    String userId,
  ) async {
    try {
      await _http.delete(
        url:
            '$remoteBaseUrl/rest/v1/question_questionnaire_link?question_id=eq.$questionId&questionnaire_id=eq.$questionnaireId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error removing question from questionnaire',
          level: 'error',
          extra: {
            'context': 'QuestionService.removeQuestionFromQuestionnaire',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  // add question to question_bucket (link)
  Future<void> addQuestionToQuestionBucket(
    String accessToken,
    String questionId,
    String questionBucketId,
    String userId,
  ) async {
    try {
      await _http.post(
        url: '$remoteBaseUrl/rest/v1/question_bucket_map',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          'question_id': questionId,
          'question_bucket_id': questionBucketId,
          'created_by': userId,
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error adding question to question bucket',
          level: 'error',
          extra: {
            'context': 'QuestionService.addQuestionToQuestionBucket',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  // remove question from question_bucket (unlink)
  Future<void> removeQuestionFromQuestionBucket(
    String accessToken,
    String questionId,
    String questionBucketId,
  ) async {
    try {
      await _http.delete(
        url:
            '$remoteBaseUrl/rest/v1/question_bucket_map?question_id=eq.$questionId&question_bucket_id=eq.$questionBucketId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error removing question from question bucket',
          level: 'error',
          extra: {
            'context': 'QuestionService.removeQuestionFromQuestionBucket',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }
}

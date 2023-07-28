// Path: lib/services/survey_service.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/answer.dart';
import 'package:empylo_app/models/job.dart';
import 'package:empylo_app/models/question.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';

class SurveyService {
  final HttpClient _client;
  final SentryService _sentry;

  SurveyService({required HttpClient client, required SentryService sentry})
      : _client = client,
        _sentry = sentry;

  Future<List<Question>> getQuestions(
      String accessToken, String campaignId) async {
    try {
      final response = await _client.get(
        url:
            '$remoteBaseUrl/rest/v1/campaign_questions?campaign_id=eq.$campaignId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.data is List) {
        return response.data
            .map<Question>((question) => Question.fromJson(question))
            .toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching survey questions',
          level: 'error',
          extra: {'context': 'SurveyService.getQuestions', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<Answer> submitAnswer(String accessToken, Answer answer) async {
    try {
      final response = await _client.post(
        url: '$remoteBaseUrl/rest/v1/answers',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: answer.toJson(),
      );

      if (response.data != null) {
        return Answer.fromJson(response.data);
      } else {
        throw Exception('Failed to submit answer');
      }
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error submitting answer',
          level: 'error',
          extra: {'context': 'SurveyService.submitAnswer', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<List<Answer>> submitAnswers(
      String accessToken, List<Answer> answers) async {
    try {
      final response = await _client.post(
        url: '$remoteBaseUrl/rest/v1/answers',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: answers.map((answer) => answer.toJson()).toList(),
      );

      if (response.data != null) {
        return (response.data as List)
            .map((item) => Answer.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to submit answers');
      }
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error submitting answers',
          level: 'error',
          extra: {'context': 'SurveyService.submitAnswers', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<Job> getJob(String accessToken, String jobId) async {
    try {
      final response = await _client.get(
        url: '$remoteBaseUrl/rest/v1/jobs?id=eq.$jobId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.data != null && response.data.isNotEmpty) {
        return Job.fromJson(response.data[0]);
      } else {
        throw Exception('Failed to get job');
      }
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error getting job',
          level: 'error',
          extra: {'context': 'SurveyService.getJob', 'error': e},
        ),
      );
      rethrow;
    }
  }
}

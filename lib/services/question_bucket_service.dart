import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/question_bucket.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';

class QuestionBucketService {
  final HttpClient _client;
  final SentryService _sentry;

  QuestionBucketService(
      {required HttpClient client, required SentryService sentry})
      : _client = client,
        _sentry = sentry;

  Future<List<QuestionBucket>> getQuestionBuckets(
      String accessToken, String userRole, String companyId) async {
    try {
      final url = _getQuestionBucketUrl(userRole, companyId);
      final response = await _client.get(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response.data
          .map<QuestionBucket>(
              (questionBucket) => QuestionBucket.fromJson(questionBucket))
          .toList();
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching question buckets',
          level: 'error',
          extra: {
            'context': 'QuestionBucketService.getQuestionBuckets',
            'error': e
          },
        ),
      );
      rethrow;
    }
  }

  Future<QuestionBucket> createQuestionBucket(
      String accessToken,
      QuestionBucket questionBucket,
      String userId,
      String userRole,
      String companyId) async {
    try {
      final url = _getQuestionBucketUrl(userRole, companyId);
      final response = await _client.post(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: questionBucket.toJson(),
      );
      return QuestionBucket.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error creating question bucket',
          level: 'error',
          extra: {
            'context': 'QuestionBucketService.createQuestionBucket',
            'error': e
          },
        ),
      );
      rethrow;
    }
  }

  Future<QuestionBucket> updateQuestionBucket(
      String accessToken,
      String bucketId,
      Map<String, dynamic> data,
      String userId,
      String userRole,
      String companyId) async {
    try {
      final url = _getQuestionBucketUrl(userRole, companyId);
      final response = await _client.patch(
        url: '$url?id=eq.$bucketId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: data,
      );
      return QuestionBucket.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error updating question bucket',
          level: 'error',
          extra: {
            'context': 'QuestionBucketService.updateQuestionBucket',
            'error': e
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteQuestionBucket(String accessToken, String bucketId,
      String userId, String userRole, String companyId) async {
    try {
      final url = _getQuestionBucketUrl(userRole, companyId);
      final response = await _client.delete(
        url: '$url?id=eq.$bucketId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode != 204) {
        throw Exception('Failed to delete question bucket');
      }
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error deleting question bucket',
          level: 'error',
          extra: {
            'context': 'QuestionBucketService.deleteQuestionBucket',
            'error': e
          },
        ),
      );
      rethrow;
    }
  }

  String _getQuestionBucketUrl(String userRole, String companyId) {
    if (userRole == 'superAdmin') {
      return '$remoteBaseUrl/rest/v1/question_buckets';
    } else if (userRole == 'admin') {
      return '$remoteBaseUrl/rest/v1/question_buckets?company_id=eq.$companyId';
    } else {
      throw Exception('Unauthorized');
    }
  }
}

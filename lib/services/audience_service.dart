// Path: lib/state_management/campaigns/audience_survency.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/utils/role_based_url.dart';

class AudienceService {
  final SentryService _sentry;
  final HttpClient _http;

  AudienceService({
    required SentryService sentry,
    required HttpClient http,
  })  : _sentry = sentry,
        _http = http;

  Future<List<Audience>> getAudiences(
      String companyId, String accessToken, String userRole,
      {String? audienceId}) async {
    try {
      final filter = getRoleBasedFilter(userRole, companyId);
      final url = getRoleBasedUrl(
        userRole,
        companyId,
        'rest/v1/audiences',
        queryParams: {
          'id': 'eq.$companyId',
        },
      );
      final response = await _http.get(
        url: url + (audienceId != null ? '?id=eq.$audienceId$filter' : filter),
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response.data
          .map<Audience>((audience) => Audience.fromJson(audience))
          .toList();
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching audiences',
          level: 'error',
          extra: {
            'context': 'AudienceService.getAudiences',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<Audience> createAudience(
      String companyId, String accessToken, Audience audience) async {
    try {
      final response = await _http.post(
        url: '$remoteBaseUrl/rest/v1/audiences',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: audience.toJson(),
      );
      return Audience.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error creating audience',
          level: 'error',
          extra: {
            'context': 'AudienceService.createAudience',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<Audience> updateAudience(String companyId, String accessToken,
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _http.patch(
        url: '$remoteBaseUrl/rest/v1/audiences?id=eq.$id',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: data,
      );
      return Audience.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error updating audience',
          level: 'error',
          extra: {
            'context': 'AudienceService.updateAudience',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteAudience(
      String companyId, String accessToken, String id) async {
    try {
      final response = await _http.delete(
        url: '$remoteBaseUrl/rest/v1/audiences?id=eq.$id',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode != 204) {
        throw Exception('Failed to delete audience');
      }
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error deleting audience',
          level: 'error',
          extra: {
            'context': 'AudienceService.deleteAudience',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }
}

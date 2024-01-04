// Path: lib/services/audience_user_service.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/audience_member.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/models/user_audience_link.dart';
import 'package:empylo_app/services/http/http_client.dart';
import 'package:empylo_app/services/sentry/sentry_service.dart';
import 'package:empylo_app/utils/role_based_url.dart';

class AudienceUserService {
  final SentryService _sentry;
  final HttpClient _http;

  AudienceUserService({
    required SentryService sentry,
    required HttpClient http,
  })  : _sentry = sentry,
        _http = http;

  Future<List<AudienceMember>> getUsersInAudience(String audienceId,
      String accessToken, String userRole, String companyId) async {
    try {
      String url =
          '$remoteBaseUrl/rest/v1/audience_users?audience_id=eq.$audienceId${getRoleBasedFilter(userRole, companyId)}';

      final response = await _http.get(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = response.data as List<dynamic>;
      final audienceMembers = data
          .map((json) => AudienceMember.fromJson(json as Map<String, dynamic>))
          .toList();
      return audienceMembers;
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching users in audience',
          level: 'error',
          extra: {
            'context': 'AudienceService.getUsersInAudience',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> addUserToAudience(
      String accessToken, UserAudienceLink userAudienceLink) async {
    await _http.post(
      url: '$remoteBaseUrl/rest/v1/user_audience_link',
      headers: {
        'apikey': remoteAnonKey,
        'Authorization': 'Bearer $accessToken',
        'Prefer': 'return=representation',
      },
      data: userAudienceLink.toJson(),
    );
  }

  Future<void> removeUserFromAudience(
      String accessToken, String audienceId, String userId) async {
    await _http.delete(
      url:
          '$remoteBaseUrl/rest/v1/user_audience_link?audience_id=eq.$audienceId&user_id=eq.$userId',
      headers: {
        'apikey': remoteAnonKey,
        'Authorization': 'Bearer $accessToken',
      },
    );
  }
}

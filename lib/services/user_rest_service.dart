// Path: lib/services/user_rest_service.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';

class UserRestService {
  final HttpClient _client;
  final SentryService _sentry;

  UserRestService({required HttpClient client, required SentryService sentry})
      : _client = client,
        _sentry = sentry;

  Future<UserProfile> getUserProfile(String id, String accessToken) async {
    try {
      final response = await _client.get(
        url: '$remoteBaseUrl/rest/v1/users?id=eq.$id&select=*',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      print('getUserProfile: ${response.data}');
      return UserProfile.fromJson(response.data);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching user profile',
          level: 'error',
          extra: {'context': 'UserRestService.getUserProfile', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<UserProfile> updateUserProfile(
      String id, Map<String, dynamic> updates, String accessToken) async {
    try {
      final response = await _client.put(
        url: '$remoteBaseUrl/rest/v1/users/id=eq.$id',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: updates,
      );
      return UserProfile.fromJson(response.data);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error updating user profile',
          level: 'error',
          extra: {'context': 'UserRestService.updateUserProfile', 'error': e},
        ),
      );
      rethrow;
    }
  }
}

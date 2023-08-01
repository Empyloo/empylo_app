// Path: lib/services/user_rest_service.dart
import 'dart:convert';

import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/models/team.dart';
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/models/user_team_mapping.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';

class UserRestService {
  final HttpClient _client;
  final SentryService _sentry;

  UserRestService({required HttpClient client, required SentryService sentry})
      : _client = client,
        _sentry = sentry;

  Future<List<UserTeamMapping>> getUserTeams(
      String userId, String accessToken) async {
    try {
      final response = await _client.get(
        url:
            '$remoteBaseUrl/rest/v1/user_team_mapping?user_id=eq.$userId', //&select=team_id!team(*,company(*))',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response.data
          .map<UserTeamMapping>((mapping) => UserTeamMapping.fromJson(mapping))
          .toList();
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching user teams',
          level: 'error',
          extra: {'context': 'UserRestService.getUserTeams', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<UserProfile> getUserProfile(String id, String accessToken) async {
    try {
      final response = await _client.get(
        url: '$remoteBaseUrl/rest/v1/users?id=eq.$id&select=*',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      return UserProfile.fromJson(response.data[0]);
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
      final response = await _client.patch(
        url: '$remoteBaseUrl/rest/v1/users?id=eq.$id',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
        },
        data: updates,
      );
      print('response.data: ${response.data[0]}');
      return UserProfile.fromJson(response.data[0]);
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

  Future<void> deleteUserProfile(String id, String accessToken) async {
    try {
      await _client.delete(
        url: '$remoteBaseUrl/rest/v1/users?id=eq.$id',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error deleting user account',
          level: 'error',
          extra: {'context': 'UserRestService.deleteUserAccount', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<List<UserProfile>> getUserProfiles(String accessToken) async {
    try {
      final response = await _client.get(
        url: '$remoteBaseUrl/rest/v1/users?select=*',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        },
      );
      return List<UserProfile>.from(
          response.data.map((userData) => UserProfile.fromJson(userData)));
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching user profiles',
          level: 'error',
          extra: {'context': 'UserRestService.getUserProfiles', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<List<Team>> getCompanyTeams(
      String companyId, String accessToken) async {
    try {
      final response = await _client.get(
        url: '$remoteBaseUrl/rest/v1/teams?company_id=eq.$companyId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      return List<Team>.from(
          response.data.map((teamData) => Team.fromJson(teamData)));
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching company teams',
          level: 'error',
          extra: {'context': 'UserRestService.getCompanyTeams', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<void> addUserToTeam(String userId, String teamId, String companyId,
      String accessToken) async {
    try {
      await _client.post(
        url: '$remoteBaseUrl/rest/v1/user_team_mapping',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
        },
        data: json.encode({
          'user_id': userId,
          'team_id': teamId,
          'company_id': companyId,
        }),
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error adding user to team',
          level: 'error',
          extra: {'context': 'UserRestService.addUserToTeam', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<Team> createTeam(
      Map<String, dynamic> teamData, String accessToken) async {
    try {
      final response = await _client.post(
        url: '$remoteBaseUrl/rest/v1/teams',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
        },
        data: json.encode(teamData),
      );
      return Team.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error creating team',
          level: 'error',
          extra: {'context': 'UserRestService.createTeam', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<void> removeUserFromTeam(
      String userId, String teamId, String accessToken) async {
    try {
      await _client.delete(
        url:
            '$remoteBaseUrl/rest/v1/user_team_mapping?user_id=eq.$userId&team_id=eq.$teamId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error removing user from team',
          level: 'error',
          extra: {'context': 'UserRestService.removeUserFromTeam', 'error': e},
        ),
      );
      rethrow;
    }
  }
}

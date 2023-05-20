import 'package:empylo_app/models/team.dart';
import 'package:empylo_app/models/user_team_mapping.dart';
import 'package:empylo_app/services/user_rest_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_rest_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamData {
  final List<Team> companyTeams;
  final List<UserTeamMapping> userTeams;

  TeamData({required this.companyTeams, required this.userTeams});
}

class TeamDataNotifier extends StateNotifier<TeamData> {
  final UserRestService _userRestService;
  final Future<dynamic> _accessBoxFuture;

  TeamDataNotifier(this._userRestService, this._accessBoxFuture)
      : super(TeamData(companyTeams: [], userTeams: []));

  Future<void> fetchTeamsData(
      String userId, String companyId, String accessToken,
      {required void Function(dynamic) onError}) async {
    try {
      final companyTeams =
          await _userRestService.getCompanyTeams(companyId, accessToken);
      final userTeams =
          await _userRestService.getUserTeams(userId, accessToken);

      // Update the 'selected' field for each team based on the userTeams
      for (var team in companyTeams) {
        team.selected = userTeams.any((userTeam) => userTeam.teamId == team.id);
      }

      state = TeamData(companyTeams: companyTeams, userTeams: userTeams);
    } catch (e) {
      onError(e);
    }
  }

  Future<TeamData> fetchAllData(String userId, String companyId,
      {required void Function(dynamic) onError}) async {
    try {
      final box = await _accessBoxFuture;
      final accessToken = box.get('session')['access_token'];
      await fetchTeamsData(userId, companyId, accessToken, onError: onError);
      return state;
    } catch (e) {
      onError(e);
      rethrow;
    }
  }

  Future<void> addUserToTeam(
      String userId, String teamId, String companyId, TeamData teamData,
      {required void Function(dynamic) onError}) async {
    try {
      final box = await _accessBoxFuture;
      final accessToken = box.get('session')['access_token'];
      await _userRestService.addUserToTeam(
          userId, teamId, companyId, accessToken);
      await fetchTeamsData(userId, companyId, accessToken, onError: onError);
    } catch (e) {
      onError(e);
    }
  }

  Future<void> removeUserFromTeam(
      String userId, String teamId, TeamData teamData,
      {required void Function(dynamic) onError}) async {
    try {
      final box = await _accessBoxFuture;
      final accessToken = box.get('session')['access_token'];
      await _userRestService.removeUserFromTeam(userId, teamId, accessToken);
      await fetchTeamsData(
          userId, teamData.companyTeams[0].companyId, accessToken,
          onError: onError);
    } catch (e) {
      onError(e);
    }
  }
}

final teamDataNotifierProvider =
    StateNotifierProvider<TeamDataNotifier, TeamData>((ref) {
  final userRestService = ref.watch(userRestServiceProvider);
  final accessBoxFuture = ref.watch(accessBoxProvider.future);
  return TeamDataNotifier(userRestService, accessBoxFuture);
});

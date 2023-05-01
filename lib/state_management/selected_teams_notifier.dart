// Path: lib/state_management/selected_teams_notifier.dart
import 'package:empylo_app/services/user_rest_service.dart';
import 'package:empylo_app/state_management/user_rest_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/models/team.dart';

class SelectedTeamsNotifier extends StateNotifier<List<Team>> {
  final UserRestService _userRestService;

  SelectedTeamsNotifier(this._userRestService) : super([]);

  Future<void> fetchUserTeams(String userId, String accessToken) async {
    final teams = await _userRestService.getUserTeams(userId, accessToken);
    state = teams;
  }

  Future<void> addUserToTeam(String userId, String teamId, String companyId,
      String accessToken) async {
    await _userRestService.addUserToTeam(
        userId, teamId, companyId, accessToken);
    fetchUserTeams(userId, accessToken);
  }

  Future<void> removeUserFromTeam(
      String userId, String teamId, String accessToken) async {
    await _userRestService.removeUserFromTeam(userId, teamId, accessToken);
    fetchUserTeams(userId, accessToken);
  }
}

// Create a provider for the SelectedTeamsNotifier
final selectedTeamsNotifierProvider =
    StateNotifierProvider<SelectedTeamsNotifier, List<Team>>(
  (ref) {
    final userRestService = ref.watch(userRestServiceProvider);
    return SelectedTeamsNotifier(userRestService);
  },
);

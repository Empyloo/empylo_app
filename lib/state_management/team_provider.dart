// Path: lib/providers/team_provider.dart
import 'package:empylo_app/models/team.dart';
import 'package:empylo_app/services/user_rest_service.dart';
import 'package:empylo_app/state_management/user_rest_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamNotifier extends StateNotifier<List<Team>> {
  final UserRestService _userService;

  TeamNotifier({required UserRestService userService})
      : _userService = userService,
        super([]);

  Future<void> getTeamsForCompany(String companyId, String accessToken) async {
    try {
      final teams = await _userService.getCompanyTeams(companyId, accessToken);
      state = teams;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  Future<void> getTeamsForUser(String userId, String accessToken) async {
    try {
      final teams = await _userService.getUserTeams(userId, accessToken);
      state = teams;
    } catch (e) {
      state = [];
      rethrow;
    }
  }
}

final teamNotifierProvider =
    StateNotifierProvider<TeamNotifier, List<Team>>((ref) {
  final userService = ref.watch(userRestServiceProvider);
  return TeamNotifier(userService: userService);
});

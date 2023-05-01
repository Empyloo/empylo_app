// Path: lib/state_management/company_teams_notifier.dart
import 'package:empylo_app/models/team.dart';
import 'package:empylo_app/services/user_rest_service.dart';
import 'package:empylo_app/state_management/user_rest_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyTeamsNotifier extends StateNotifier<List<Team>> {
  final UserRestService _userRestService;

  CompanyTeamsNotifier(this._userRestService) : super([]);

  Future<void> fetchCompanyTeams(String companyId, String accessToken) async {
    final teams =
        await _userRestService.getCompanyTeams(companyId, accessToken);
    state = teams;
  }
}

// Create a provider for the CompanyTeamsNotifier
final companyTeamsNotifierProvider =
    StateNotifierProvider<CompanyTeamsNotifier, List<Team>>(
  (ref) {
    final userRestService = ref.watch(userRestServiceProvider);
    return CompanyTeamsNotifier(userRestService);
  },
);

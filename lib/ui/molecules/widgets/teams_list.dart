// Path: lib/ui/molecules/widgets/teams_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/state_management/selected_teams_notifier.dart';
import 'package:empylo_app/state_management/company_teams_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';

class TeamList extends ConsumerWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileNotifierProvider);
    final String userId = userProfile?.id ?? '';
    final String companyID = userProfile?.companyID ?? '';

    return FutureBuilder(
      future: ref.read(accessBoxProvider.future),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final accessBox = snapshot.data;
          final session = accessBox.get('session');
          final String accessToken = session['access_token'];

          ref
              .read(companyTeamsNotifierProvider.notifier)
              .fetchCompanyTeams(userId, accessToken);
          ref
              .read(selectedTeamsNotifierProvider.notifier)
              .fetchUserTeams(userId, accessToken);

          final companyTeams = ref.watch(companyTeamsNotifierProvider);
          final selectedTeams = ref.watch(selectedTeamsNotifierProvider);

          return ListView.builder(
            itemCount: companyTeams.length,
            itemBuilder: (context, index) {
              final team = companyTeams[index];
              bool isSelected = selectedTeams
                  .any((selectedTeam) => selectedTeam.id == team.id);

              return ListTile(
                title: Text(team.name),
                subtitle: Text(team.description ?? 'No description'),
                trailing: isSelected
                    ? IconButton(
                        icon:
                            const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () {
                          ref
                              .read(selectedTeamsNotifierProvider.notifier)
                              .removeUserFromTeam(userId, team.id, accessToken);
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: Colors.grey),
                        onPressed: () {
                          ref
                              .read(selectedTeamsNotifierProvider.notifier)
                              .addUserToTeam(
                                  userId, team.id, companyID, accessToken);
                        },
                      ),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

// Path: lib/ui/molecules/widgets/teams_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/state_management/team_data_notifier.dart';

class TeamList extends ConsumerWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileNotifierProvider);
    final String userId = userProfile?.id ?? '';
    final String companyID = userProfile?.companyID ?? '';

    onError(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    return FutureBuilder(
      future: ref
          .watch(teamDataNotifierProvider.notifier)
          .fetchAllData(userId, companyID, onError: onError),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Error: Unable to fetch team data');
        } else {
          final teamData = ref.watch(teamDataNotifierProvider);
          final companyTeams = teamData.companyTeams;

          List<Widget> teamWidgets = companyTeams
              .map((team) => ListTile(
                    tileColor: team.selected ? Colors.grey[200] : Colors.white,
                    title: Text(
                      team.name,
                      style: TextStyle(
                        fontWeight:
                            team.selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: IconButton(
                      icon: team.selected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.add_circle_outline,
                              color: Colors.grey),
                      onPressed: () async {
                        final teamDataNotifier =
                            ref.read(teamDataNotifierProvider.notifier);
                        if (team.selected) {
                          await teamDataNotifier.removeUserFromTeam(
                              userId, team.id, teamData,
                              onError: onError);
                        } else {
                          await teamDataNotifier.addUserToTeam(
                              userId, team.id, companyID, teamData,
                              onError: onError);
                        }
                      },
                    ),
                  ))
              .toList();

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select a team/s',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: teamWidgets,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

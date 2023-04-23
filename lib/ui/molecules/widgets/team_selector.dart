// Path: lib/ui/molecules/widgets/team_selector.dart
import 'package:empylo_app/models/team.dart';
import 'package:empylo_app/state_management/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamSelector extends ConsumerWidget {
  const TeamSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamNotifierProvider);

    if (teams.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Column(
        children: teams.map((team) {
          return TeamButton(
            team: team,
            selected: ref.watch(_selectedTeam),
            onPressed: () {
              // Toggle the selected state of the team.
              ref.read(_selectedTeam).state = !ref.read(_selectedTeam).state;

              // Save the selected team to the database.
              // ...
            },
          );
        }).toList(),
      ),
    );
  }
}


final _selectedTeam = StateProvider<bool>((ref) => false);

class TeamButton extends ConsumerWidget {
  const TeamButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamNotifierProvider.notifier);
    final selected = ref.watch(_selectedTeam);

    return TextButton.icon(
      onPressed: () {
        ref.read(_selectedTeam).state = !selected.state;
        // Perform save operation here or store the selected teams in a separate state
      },
      icon: Icon(selected.state ? Icons.delete : Icons.add),
      label: Text(team.name),
    );
  }
}

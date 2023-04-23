// Path: lib/ui/molecules/widgets/teams.dart
import 'package:empylo_app/state_management/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamList extends ConsumerWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamNotifierProvider);

    if (teams.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return ListTile(
          title: Text(team.name),
          subtitle: Text(team.description ?? ''),
        );
      },
    );
  }
}

/*
How to use this widget:
// ...
Scaffold(
  body: TeamList(),
)
// ...

*/ 
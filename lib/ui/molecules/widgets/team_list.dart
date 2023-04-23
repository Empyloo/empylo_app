import 'package:empylo_app/ui/molecules/widgets/team.dart';
import 'package:flutter/material.dart';

class TeamList extends StatelessWidget {
  final List<Team> teams;

  const TeamList({super.key, 
    required this.teams,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        return Team(
          name: teams[index].name,
          selected: teams[index].selected,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class Team extends StatelessWidget {
  final String name;
  late bool selected;

  Team({super.key, 
    required this.name,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Toggle the selected state of the team.
        selected = !selected;

        // If the team is selected, call the `addUserToTeam` method to add the user to the team.
        if (selected) {
          addUserToTeam(name);
        }

        // If the team is not selected, call the `removeUserFromTeam` method to remove the user from the team.
        else {
          removeUserFromTeam(name);
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check : Icons.add,
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Text(name),
          ],
        ),
      ),
    );
  }
}

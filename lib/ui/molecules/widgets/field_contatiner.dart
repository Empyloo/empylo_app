// Path: lib/ui/molecules/widgets/field_contatiner.dart 
import 'package:flutter/material.dart';

Widget buildFieldContainer({required Widget child}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: child,
  );
}

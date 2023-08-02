import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  TextSpan boldFirstThreeOfEach() {
    return TextSpan(
      children: split(' ').map((word) {
        return TextSpan(
          children: [
            TextSpan(
              text: word.substring(0, 3),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: word.substring(3)),
            const TextSpan(text: ' '),
          ],
        );
      }).toList(),
    );
  }
}

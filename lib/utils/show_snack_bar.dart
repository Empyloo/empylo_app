// Path: lib/utils/show_snack_bar.dart
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,
    {required String message,
    IconData? icon,
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 3)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(message),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}

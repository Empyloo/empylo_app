// Path: lib/utils/error_handler.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  final BuildContext context;

  ErrorHandler(this.context);

  void handleError(Object error, {bool showUser = true}) {
    // Detailed Logging
    if (kDebugMode) {
      print(error);
    } // log the error

    // User Feedback
    if (showUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

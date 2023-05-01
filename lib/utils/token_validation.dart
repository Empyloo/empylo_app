// Path: lib/utils/token_validation.dart
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<bool?> handleTokenValidation({
  required String? accessToken,
  required String? refreshToken,
  required WidgetRef ref,
  required BuildContext context,
}) async {
  if (accessToken != null && refreshToken != null) {
    final response = await ref.read(userProvider.notifier).validateToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        ref: ref,
        context: context);
    return response;
  } else {
    print('No tokens found.');
    showDialog(
      context: context,
      builder: (context) => const SnackBar(content: Text('No tokens found')),
    );
    return null;
  }
}

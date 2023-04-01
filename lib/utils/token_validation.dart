// Path: lib/utils/token_validation.dart
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<void> handleTokenValidation({
  required String? accessToken,
  required String? refreshToken,
  required ProviderRef<GoRouter> ref,
  required BuildContext context,
}) async {
  if (accessToken != null && refreshToken != null) {
    print('Tokens found: validating...');
    await ref.read(userProvider.notifier).validateToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        ref: ref,
        context: context);
    print('Token validation completed.');
  } else {
    print('No tokens found.');
  }
}

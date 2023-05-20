// Path: lib/utils/user_utils/is_authanticated.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool isAuthenticated(BuildContext context, ProviderRef ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isAuthenticated;
}

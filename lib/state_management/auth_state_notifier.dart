// Path: lib/state_management/auth_state_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStateNotifier extends StateNotifier<bool> {
  AuthStateNotifier() : super(false);

  void login() {
    state = true;
  }

  void logout() {
    state = false;
  }
}

// Create a provider for the AuthStateNotifier
final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  return AuthStateNotifier();
});

// Path: lib/state_management/auth_state_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { user, admin, superAdmin }

class AuthState {
  bool isAuthenticated;
  UserRole role;

  AuthState({required this.isAuthenticated, required this.role});
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier()
      : super(AuthState(isAuthenticated: false, role: UserRole.user));

  void login(UserRole role) {
    state = AuthState(isAuthenticated: true, role: role);
  }

  void logout() {
    state = AuthState(isAuthenticated: false, role: UserRole.user);
  }
}

// Create a provider for the AuthStateNotifier
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

// Path: lib/state_management/login_state_provider.dart
import 'package:empylo_app/models/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginStateNotifier extends StateNotifier<LoginState> {
  LoginStateNotifier()
      : super(LoginState(
          email: TextEditingController(),
          password: TextEditingController(),
          obscureText: true,
          loading: false,
          isDialogOpened: false,
        ));

  void toggleDialogState(bool opened) {
    state = state.copyWith(isDialogOpened: opened);
  }
  void toggleObscureText() {
    state = state.copyWith(obscureText: !state.obscureText);
  }

  void toggleLoading() {
    state = state.copyWith(loading: !state.loading);
  }

  void clearTextFields() {
    state.email.clear();
    state.password.clear();
  }

  void disposeControllers() {
    state.email.dispose();
    state.password.dispose();
  }
}

final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, LoginState>(
        (ref) => LoginStateNotifier());

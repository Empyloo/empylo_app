// Path: lib/models/login_state.dart
import 'package:flutter/material.dart';

class LoginState {
  const LoginState({
    required this.email,
    required this.password,
    required this.obscureText,
    required this.isDialogOpened,
    this.loading = false,
  });

  final TextEditingController email;
  final TextEditingController password;
  final bool obscureText;
  final bool isDialogOpened;
  final bool loading;

  LoginState copyWith({
    TextEditingController? email,
    TextEditingController? password,
    bool? obscureText,
    bool? isDialogOpened,
    bool? loading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscureText: obscureText ?? this.obscureText,
      isDialogOpened: isDialogOpened ?? this.isDialogOpened,
      loading: loading ?? this.loading,
    );
  }
}

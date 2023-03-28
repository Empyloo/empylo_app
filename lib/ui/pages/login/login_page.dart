// Path: lib/ui/pages/login/login_page.dart
import 'package:empylo_app/state_management/login_state_provider.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/ui/molecules/dialogues/remove_factor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state_management/user_provider.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  void onLoginButtonPressed(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.notifier);
    final loginState = ref.watch(loginStateProvider);

    user.login(
      email: loginState.email.text,
      password: loginState.password.text,
      ref: ref,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginStateProvider);
    final user = ref.watch(userProvider.notifier);

    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loginState.loading
            ? const CircularProgressIndicator()
            : Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: !loginState.isDialogOpened,
                      controller: loginState.email,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: const OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: loginState.password,
                      obscureText: loginState.obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginState.obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            ref
                                .read(loginStateProvider.notifier)
                                .toggleObscureText();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        user.login(
                          email: loginState.email.text,
                          password: loginState.password.text,
                          ref: ref,
                          context: context,
                        );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: borderRadius,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue.shade500,
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

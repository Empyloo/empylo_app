// Path: lib/ui/pages/login/set_password_page.dart
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setPasswordControllerProvider =
    Provider((ref) => TextEditingController());
final setPasswordLoadingStateProvider = StateProvider<bool>((ref) => false);

class SetPasswordPage extends ConsumerWidget {
  final String? accessToken;
  final String? refreshToken;

  const SetPasswordPage(
      {Key? key, required this.accessToken, required this.refreshToken})
      : super(key: key);

  void showSnackBarCallback(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController passwordController =
        ref.watch(setPasswordControllerProvider);
    final user = ref.watch(userProvider.notifier);
    final isLoading = ref.watch(setPasswordLoadingStateProvider);

    final bool hasValidTokens = accessToken != null;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Set New Password'),
        ),
        body: hasValidTokens
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your new password',
                          border: OutlineInputBorder(),
                          constraints: BoxConstraints(maxWidth: 300),
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                ref
                                    .read(setPasswordLoadingStateProvider
                                        .notifier)
                                    .state = true;
                                print('Set New Password');
                                // Call your set password function here and pass the new password
                                await user.setPassword(
                                  password: passwordController.text,
                                  accessToken: accessToken!,
                                  context: context,
                                  showSnackBarCallback:
                                      (String message, Color color) =>
                                          showSnackBarCallback(
                                              context, message, color),
                                );
                                ref
                                    .read(setPasswordLoadingStateProvider
                                        .notifier)
                                    .state = false;
                                // clear the password text field
                                passwordController.clear();
                                // Navigate to the login page
                                ref.read(routerProvider).go('/login');
                              },
                              child: const Text('Set New Password'),
                            ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You don't have an access token or it has expired.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(routerProvider).go('/login');
                        },
                        child: const Text('Go to Login Page'),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

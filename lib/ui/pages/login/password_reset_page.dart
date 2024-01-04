// Path: lib/state_management/user_rest_service_provider.dart
import 'package:empylo_app/state_management/routing/router_provider.dart';
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final passwordResetEmailControllerProvider =
    Provider((ref) => TextEditingController());
final passwordResetLoadingStateProvider = StateProvider<bool>((ref) => false);

class PasswordResetPage extends ConsumerWidget {
  const PasswordResetPage({super.key});

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
    final TextEditingController emailController =
        ref.watch(passwordResetEmailControllerProvider);
    final user = ref.watch(userProvider.notifier);
    final isLoading = ref.watch(passwordResetLoadingStateProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  constraints: BoxConstraints(maxWidth: 300),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            ref
                                .read(
                                    passwordResetLoadingStateProvider.notifier)
                                .state = true;
                            // Call your password reset function here and pass the email
                            await user.passwordReset(
                              email: emailController.text,
                              context: context,
                              showSnackBarCallback: (String message,
                                      Color color) =>
                                  showSnackBarCallback(context, message, color),
                            );
                            ref
                                .read(
                                    passwordResetLoadingStateProvider.notifier)
                                .state = false;
                            // clear the email text field
                            emailController.clear();
                            // Navigate to the login page
                            ref.read(routerProvider).go('/');
                          },
                          child: const Text('Send Password Reset Email'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            // Navigate to the login page
                            GoRouter.of(context).go('/');
                          },
                          child: const Text('Back to Login'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

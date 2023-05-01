import 'package:empylo_app/models/redirect_params.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/state_management/token_provider.dart';
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setPasswordControllerProvider =
    Provider((ref) => TextEditingController());
final setPasswordLoadingStateProvider = StateProvider<bool>((ref) => false);

class SetPasswordPage extends ConsumerWidget {
  final RedirectParams redirectParams;

  const SetPasswordPage({Key? key, required this.redirectParams})
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
    final accessBox = ref.watch(accessBoxProvider);

    // Call handleTokenValidation here
    ref.read(tokenValidationStateProvider.notifier).handleTokenValidation(
          accessToken: redirectParams.accessToken,
          refreshToken: redirectParams.refreshToken,
          ref: ref,
          context: context,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set New Password'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final tokenValidationState = ref.watch(tokenValidationStateProvider);

        return tokenValidationState.when(
          data: (hasValidTokens) {
            if (!hasValidTokens) {
              return const ErrorPage("Invalid Tokens/Session.");
            }

            // Rest of the widget code when tokens are valid
            return Center(
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
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (hasValidTokens) {
                                ref
                                    .read(setPasswordLoadingStateProvider
                                        .notifier)
                                    .state = true;
                                print('Set New Password');
                                final setPassAccessToken = accessBox.value
                                        ?.get('session')
                                        ?.get('access_token') ??
                                    redirectParams.accessToken;
                                print(
                                    'setPassAccessToken: $setPassAccessToken');
                                try {
                                  await user.setPassword(
                                    password: passwordController.text,
                                    accessToken: setPassAccessToken,
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
                                  passwordController.clear();
                                  ref.read(routerProvider).go('/');
                                } catch (e) {
                                  ref
                                      .read(setPasswordLoadingStateProvider
                                          .notifier)
                                      .state = false;
                                  showSnackBarCallback(
                                      context, e.toString(), Colors.red);
                                }
                              } else {
                                showSnackBarCallback(context,
                                    'Invalid Tokens/Session.', Colors.red);
                              }
                            },
                            child: const Text('Set New Password'),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              ref.read(routerProvider).go('/');
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const ErrorPage("An unexpected error occurred."),
        );
      }),
    );
  }
}

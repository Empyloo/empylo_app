import 'package:empylo_app/models/redirect_params.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/token_provider.dart';
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyPage extends ConsumerWidget {
  final RedirectParams redirectParams;

  const SurveyPage({Key? key, required this.redirectParams})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.notifier);
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
        title: const Text('Survey Page'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final tokenValidationState = ref.watch(tokenValidationStateProvider);

        return tokenValidationState.when(
          data: (hasValidTokens) {
            if (!hasValidTokens) {
              return const ErrorPage("Invalid Tokens/Session.");
            }

            // Rest of the widget code when tokens are valid
            // Add the survey tab here
            return const Text('Display the survey form here');
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const ErrorPage("An unexpected error occurred."),
        );
      }),
    );
  }
}

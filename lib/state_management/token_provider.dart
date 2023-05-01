import 'package:empylo_app/state_management/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenValidationStateNotifier extends StateNotifier<AsyncValue<bool>> {
  TokenValidationStateNotifier() : super(const AsyncValue.loading());

  Future<void> handleTokenValidation({
    required String accessToken,
    required String refreshToken,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      final isValid = await ref.read(userProvider.notifier).validateToken(
            accessToken: accessToken,
            refreshToken: refreshToken,
            ref: ref,
            context: context,
          );
      state = AsyncValue.data(isValid);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final tokenValidationStateProvider =
    StateNotifierProvider<TokenValidationStateNotifier, AsyncValue<bool>>(
        (ref) => TokenValidationStateNotifier());

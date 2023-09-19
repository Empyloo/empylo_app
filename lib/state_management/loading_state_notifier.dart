import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingStateNotifier extends StateNotifier<bool> {
  LoadingStateNotifier() : super(false);

  void startLoading() {
    state = true;
  }

  void stopLoading() {
    state = false;
  }
}

final loadingStateProvider = StateNotifierProvider<LoadingStateNotifier, bool>(
  (ref) => LoadingStateNotifier(),
);

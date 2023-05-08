// Path: lib/utils/request_processing_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestProcessingState extends StateNotifier<bool> {
  RequestProcessingState() : super(false);

  void start() {
    state = true;
  }

  void end() {
    state = false;
  }
}

final requestProcessingProvider =
    StateNotifierProvider<RequestProcessingState, bool>(
        (ref) => RequestProcessingState());

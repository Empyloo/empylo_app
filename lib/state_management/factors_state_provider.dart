// Path: lib/state_management/factors_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final factorsStateProvider =
    StateNotifierProvider<FactorsStateNotifier, List<dynamic>>((ref) {
  return FactorsStateNotifier();
});

class FactorsStateNotifier extends StateNotifier<List<dynamic>> {
  FactorsStateNotifier() : super([]);

  void setFactors(List<dynamic> newFactors) {
    state = newFactors;
  }

  void addFactor(dynamic factor) {
    state = [...state, factor];
  }

  void updateFactor(dynamic updatedFactor) {
    state = state.map((factor) {
      if (factor['id'] == updatedFactor['id']) {
        return updatedFactor;
      }
      return factor;
    }).toList();
  }

  void removeFactor(String factorId) {
    state = state.where((factor) => factor['id'] != factorId).toList();
  }
}

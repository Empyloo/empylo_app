// Path: lib/state_management/audiences/audience_notifier.dart
import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/services/audience_service.dart';
import 'package:empylo_app/state_management/audiences/audience_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audienceNotifierProvider =
    StateNotifierProvider<AudienceNotifier, List<Audience>>(
  (ref) {
    final audienceService = ref.read(audienceServiceProvider);
    return AudienceNotifier(audienceService);
  },
);

class AudienceNotifier extends StateNotifier<List<Audience>> {
  final AudienceService _audienceService;

  AudienceNotifier(this._audienceService) : super([]);

  Future<void> getAudiences(
      String companyId, String accessToken, String userRole,
      {String? audienceId}) async {
    try {
      final audiences = await _audienceService.getAudiences(
          companyId, accessToken, userRole,
          audienceId: audienceId);
      state = audiences;
    } catch (e) {
      throw Exception('Error fetching audiences: $e');
    }
  }

  Future<void> createAudience(
      String companyId, String userId, String accessToken, Audience audience) async {
    try {
      final newAudience = await _audienceService.createAudience(
          companyId, accessToken, audience);
      state = [...state, newAudience];
    } catch (e) {
      throw Exception('Error creating audience: $e');
    }
  }

  Future<void> updateAudience(String companyId, String accessToken,
      String audienceId, Audience updatedAudience) async {
    try {
      final updated = await _audienceService.updateAudience(
          companyId, accessToken, audienceId, updatedAudience.toJson());
      state = [
        for (final audience in state)
          if (audience.id == audienceId) updated else audience
      ];
    } catch (e) {
      throw Exception('Error updating audience: $e');
    }
  }

  Future<void> deleteAudience(
      String companyId, String accessToken, String audienceId) async {
    try {
      await _audienceService.deleteAudience(companyId, accessToken, audienceId);
      state = state.where((audience) => audience.id != audienceId).toList();
    } catch (e) {
      throw Exception('Error deleting audience: $e');
    }
  }
}

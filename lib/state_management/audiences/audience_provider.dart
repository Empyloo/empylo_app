// Path: lib/state_management/audiences/audience_provider.dart
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/services/audience_service.dart';

final audienceServiceProvider = Provider<AudienceService>((ref) {
  final HttpClient httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  return AudienceService(
    sentry: sentry,
    http: httpClient,
  );
});

final audienceProvider = StateNotifierProvider<AudienceNotifier, AudienceState>(
  (ref) {
    final audienceService = ref.watch(audienceServiceProvider);
    return AudienceNotifier(audienceService);
  },
);

class AudienceState {
  final List<Audience> audiences;
  final String? error;

  AudienceState({
    required this.audiences,
    this.error,
  });

  AudienceState copyWith({
    List<Audience>? audiences,
    String? error,
  }) {
    return AudienceState(
      audiences: audiences ?? this.audiences,
      error: error,
    );
  }
}

class AudienceNotifier extends StateNotifier<AudienceState> {
  final AudienceService _audienceService;

  AudienceNotifier(this._audienceService) : super(AudienceState(audiences: []));

  Future<void> fetchAudiences(String accessToken, String userRole,
      String companyId, String? audienceId) async {
    try {
      final audiences =
          await _audienceService.getAudiences(accessToken, userRole, companyId);
      state = state.copyWith(audiences: audiences);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createAudience(
      String companyId, String accessToken, Audience audience) async {
    try {
      final newAudience = await _audienceService.createAudience(
          companyId, accessToken, audience);
      state = state.copyWith(audiences: [...state.audiences, newAudience]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateAudience(String companyId, String accessToken,
      String audienceId, Audience audience) async {
    try {
      final updatedAudience = await _audienceService.updateAudience(
          companyId, accessToken, audienceId, audience.toJson());
      state = state.copyWith(
        audiences: state.audiences
            .map((a) => a.id == audienceId ? updatedAudience : a)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteAudience(
      String companyId, String accessToken, String audienceId) async {
    try {
      await _audienceService.deleteAudience(companyId, accessToken, audienceId);
      state = state.copyWith(
        audiences: state.audiences.where((a) => a.id != audienceId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

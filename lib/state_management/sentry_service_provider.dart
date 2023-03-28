// Path: lib/state_management/sentry_service_provider.dart
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/constants/api_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final sentryServiceProvider = Provider<SentryService>((ref) {
  final dio = Dio();
  return SentryService(
    dio: dio,
    sentryKey: sentryKey,
    projectId: projectId,
  );
});

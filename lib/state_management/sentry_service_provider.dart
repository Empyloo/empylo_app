import 'package:empylo_app/services/sentry_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final sentryServiceProvider = Provider<SentryService>((ref) {
  const String sentryKey = '3c590eaf5e55481ab572190cf4119b65';
  const String projectId = '6751717';
  final dio = Dio();
  return SentryService(
    dio: dio,
    sentryKey: sentryKey,
    projectId: projectId,
  );
});

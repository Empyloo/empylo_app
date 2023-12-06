// Path: lib/state_management/http_client_provider.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/retry_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final httpClientProvider = Provider<HttpClient>(
  (ref) => HttpClient(
    dio: Dio(),
    retryHandler: RetryHandler(),
  ),
);

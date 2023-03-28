// Path: lib/state_management/cred_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/constants/api_constants.dart';

final remoteBaseUrlProvider = Provider<String>((ref) => remoteBaseUrl);
final remoteAnonKeyProvider = Provider<String>((ref) => remoteAnonKey);

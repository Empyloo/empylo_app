// Path: lib/state_management/access_box_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Define a provider for Hive box that stores access tokens
final accessBoxProvider =
    FutureProvider<dynamic>((ref) async {
  return Hive.box<dynamic>('session');
});

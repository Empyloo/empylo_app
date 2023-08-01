// Path: lib/state_management/session_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/models/session.dart';

final sessionProvider = StateProvider<Session?>((ref) => null);

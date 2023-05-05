// lib/state_management/selected_company_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCompanyIdProvider = StateProvider<String?>((ref) => null);
final selectedCompanyNameProvider = StateProvider<String?>((ref) => null);
final selectedRoleProvider = StateProvider<String>((ref) => 'user');

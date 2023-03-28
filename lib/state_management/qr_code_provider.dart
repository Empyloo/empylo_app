// Path: lib/state_management/qr_code_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

final qrCodeProvider = StateProvider<String>((ref) {
  return '';
});

final secretCodeProvider = StateProvider<String>((ref) {
  return '';
});

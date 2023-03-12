// Path : password_reset_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordResetProvider = Provider((ref) => PasswordReset());

class PasswordReset {
  Future<void> resetPassword(String email) async {
    // Implement your password reset logic here
  }
}

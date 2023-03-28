// Path: lib/ui/pages/login/login_text_field_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginTextFieldController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}

// Add this line to your providers file
final loginTextFieldControllerProvider =
    ChangeNotifierProvider((ref) => LoginTextFieldController());

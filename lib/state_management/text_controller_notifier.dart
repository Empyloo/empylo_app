// Path: lib/state_management/text_controller_notifier.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextControllerNotifier extends StateNotifier<TextEditingController> {
  TextControllerNotifier(String initialValue)
      : super(TextEditingController(text: initialValue)) {
    state.selection = TextSelection.fromPosition(
      TextPosition(offset: state.text.length),
    );
  }
}

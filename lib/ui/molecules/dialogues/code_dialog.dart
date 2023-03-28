// Path: lib/ui/molecules/dialogues/code_dialog.dart
// Path: lib/ui/molecules/dialogues/code_dialog.dart
import 'package:flutter/material.dart';

class CodeDialog extends StatelessWidget {
  const CodeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController mfaCodeController = TextEditingController();

    return AlertDialog(
      title: const Text('Enter MFA Code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: mfaCodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter your MFA code'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(mfaCodeController.text);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

// Path: lib/ui/molecules/dialogues/code_dialog.dart
import 'package:flutter/material.dart';

class CodeDialog extends StatelessWidget {
  const CodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController mfaCodeController = TextEditingController();
    ValueNotifier<bool> isButtonDisabled = ValueNotifier<bool>(true);

    mfaCodeController.addListener(() {
      isButtonDisabled.value = mfaCodeController.text.isEmpty;
    });

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
            onChanged: (text) {
              isButtonDisabled.value = text.isEmpty;
            },
          ),
        ],
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: isButtonDisabled,
          builder: (context, value, child) {
            return TextButton(
              onPressed: value
                  ? null
                  : () {
                      Navigator.of(context).pop(mfaCodeController.text);
                    },
              style: TextButton.styleFrom(
                foregroundColor:
                    value ? Colors.grey : Theme.of(context).primaryColor,
              ),
              child: const Text('Submit'),
            );
          },
        ),
      ],
    );
  }
}

// Path: lib/ui/molecules/dialogues/mfa_dialog.dart
import 'package:empylo_app/state_management/qr_code_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MFADialog extends ConsumerWidget {
  const MFADialog({Key? key}) : super(key: key);

  void _showCopiedSnackbar(BuildContext context) {
    const snackBar =
        SnackBar(content: Text('Secret code copied to clipboard.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController mfaCodeController = TextEditingController();

    return Builder(
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text('Scan QR Code to get MFA code'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.network(ref.watch(qrCodeProvider)),
              const SizedBox(height: 16),
              TextField(
                controller: mfaCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter your MFA code',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                maxLength: 6,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ref.watch(secretCodeProvider)),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: ref.watch(secretCodeProvider)));
                      _showCopiedSnackbar(context);
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(mfaCodeController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

// Path: lib/ui/molecules/dialogues/remove_factor_dialog.dart
import 'dart:async';

import 'package:empylo_app/state_management/mfa_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FactorsDialog extends ConsumerWidget {
  final String accessToken;
  final List<dynamic> factors;

  const FactorsDialog(
      {super.key, required this.accessToken, required this.factors});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mfaService = ref.watch(mfaServiceProvider);

    return AlertDialog(
      title: const Text('Factors'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: factors.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 3,
              child: ListTile(
                tileColor: index % 2 == 0
                    ? Colors.grey.shade200
                    : Colors.grey.shade100, // Alternate row colors
                title: Text(
                  'Factor ID: ${factors[index]['id']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Updated At: ${factors[index]['updated_at']}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: factors.length >= 9
                    ? ElevatedButton(
                        onPressed: () {
                          final completer = Completer<void>();

                          completer.future.then((_) => Navigator.pop(context));

                          try {
                            mfaService
                                .unenroll(
                                  accessToken: accessToken,
                                  factorId: factors[index]['id'],
                                )
                                .then((_) => completer.complete())
                                .catchError((error) {
                              completer.completeError(error);
                            });
                          } catch (e) {
                            completer.completeError(e);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red.shade300,
                        ),
                        child: const Text('Unenroll'),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

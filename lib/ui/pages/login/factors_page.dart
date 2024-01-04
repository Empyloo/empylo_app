// Path: lib/ui/pages/login/factors_page.dart
import 'package:empylo_app/state_management/factors_state_provider.dart';
import 'package:empylo_app/state_management/mfa_service_provider.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FactorsPage extends ConsumerWidget {
  const FactorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mfaService = ref.watch(mfaServiceProvider);
    final factorsState = ref.watch(factorsStateProvider);
    final accessToken =
        ref.watch(accessBoxProvider).value?.get('session')['access_token'];

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Factors')),
      body: ListView.builder(
        itemCount: factorsState.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 3,
            child: ListTile(
              tileColor: index % 2 == 0
                  ? Colors.grey.shade200
                  : Colors.grey.shade100, // Alternate row colors
              title: Text(
                'Factor ID: ${factorsState[index]['id']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Updated At: ${factorsState[index]['updated_at']}\nStatus: ${factorsState[index]['status']}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: factorsState.length >= 9
                  ? ElevatedButton(
                      onPressed: () async {
                        try {
                          await mfaService.unenroll(
                            accessToken: accessToken,
                            factorId: factorsState[index]['id'],
                          );
                          ref
                              .read(factorsStateProvider.notifier)
                              .removeFactor(factorsState[index]['id']);
                          showSnackBar('Factor unenrolled');
                        } catch (e) {
                          showSnackBar('Error unenrolling factor');
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
    );
  }
}

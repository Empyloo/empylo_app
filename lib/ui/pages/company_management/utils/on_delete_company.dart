// Path: lib/state_management/company_list_provider.dart
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> onDeleteCompany(
    BuildContext context, String id, WidgetRef ref) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this company?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (result != null && result) {
    final success = await ref
        .read(companyListNotifierProvider.notifier)
        .deleteCompany(id, ref);
    if (!success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to delete the company.'),
        ),
      );
    }
  }
}

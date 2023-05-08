// Path: lib/ui/pages/user_management/utils/on_delete_user.dart
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> onDeleteUser(
    BuildContext context, String id, WidgetRef ref) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this user?'),
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
    String accessToken = await getAccessToken(ref);
    final success = await ref
        .read(userProfilesListProvider.notifier)
        .deleteUserProfile(id, accessToken);
    if (!success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to delete the user.'),
        ),
      );
    }
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('User deleted successfully.'),
      ),
    );
  }
}

// Path: lib/ui/pages/user/profile_page_widgets/save_changes_button.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/users/admin_edit_user_notifier.dart';
import 'package:empylo_app/ui/pages/user_management/admin_user_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FloatingActionButton adminSaveChangesButton(
    BuildContext context, WidgetRef ref, UserProfile userProfile) {
  return FloatingActionButton(
    onPressed: () async {
      try {
        String id = userProfile.id;
        final accessBox = await ref.read(accessBoxProvider.future);
        final session = accessBox.get('session');
        String accessToken = session['access_token'];
        ref
            .read(adminEditUserNotifierProvider.notifier)
            .updateUserProfile(id, userProfile.toMap(), accessToken)
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              duration: Duration(seconds: 3),
            ),
          );
          ref.read(adminHasChangesProvider.notifier).state = false;
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update profile'),
              duration: Duration(seconds: 3),
            ),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    },
    child: const Column(
      children: [
        Text('Save'),
        Icon(Icons.save),
      ],
    ),
  );
}

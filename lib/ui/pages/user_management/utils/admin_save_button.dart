import 'package:empylo_app/state_management/users/admin_user_form_notifier.dart';
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:empylo_app/utils/user_utils/get_user_profile_by_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

FloatingActionButton buildAdminSaveButton(
    WidgetRef ref, BuildContext context, String userId) {
  return FloatingActionButton(
    onPressed: () async {
      try {
        final String accessToken = await getAccessToken(ref);

        if (ref.read(adminUserFormHasChangesProvider)) {
          final userProfile = getUserProfileByIdWidgetRef(ref, userId);

          ref
              .read(userProfilesListProvider.notifier)
              .updateUserProfile(userId, userProfile!.toMap(), accessToken)
              .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User profile updated successfully'),
                duration: Duration(seconds: 2),
              ),
            );

            ref
                .read(adminUserFormHasChangesProvider.notifier)
                .setHasChanges(false);
          }).catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update user profile'),
                duration: Duration(seconds: 2),
              ),
            );
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update user profile'),
            duration: Duration(seconds: 2),
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

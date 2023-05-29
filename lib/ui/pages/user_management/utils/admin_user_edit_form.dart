// Path: lib/ui/pages/user_management/utils/admin_user_edit_form.dart
import 'dart:async';

import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/users/admin_user_form_notifier.dart';
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:empylo_app/ui/molecules/widgets/teams_list.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/utils/user_utils/get_user_profile_by_id.dart';
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/ui/pages/user/profile_page_widgets/profile_page_widgets.dart';

class AdminUserEditProfileForm extends ConsumerWidget {
  final String userId;

  AdminUserEditProfileForm({super.key, required this.userId});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = getUserProfileByIdWidgetRef(ref, userId);
    final hasChanges = ref.watch(adminUserFormHasChangesProvider);
    final userProfiles = ref.watch(userProfilesListProvider);
    // get the user profile from the userProfilesListProvider if it exists or show ErrorPage
    UserProfile? userProfile;
    try {
      userProfile = userProfiles.firstWhere(
        (userProfile) => userProfile.id == userId,
      );
    } catch (e) {
      return const ErrorPage('User profile not found.');
    }

    final emailController = Provider((ref) => TextEditingController(
          text: userProfile!.email,
        ));


    const borderRadius = BorderRadius.all(Radius.circular(16));

    if (userProfileState == null) {
      return const ErrorPage('User profile not found.');
    }

    return Form(
      child: Column(
        children: [
          VerticalSpacing.s,
          hasChanges ? unsavedChanges(context, ref) : const SizedBox.shrink(),
          VerticalSpacing.s,
          // email
          TextFormField(
            controller: ref.read(emailController),
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: borderRadius,
              ),
            ),
            onChanged: (_) {
              ref
                  .read(adminUserFormHasChangesProvider.notifier)
                  .setHasChanges(true);
            },
          ),
          VerticalSpacing.s,
          // jobTitle
          VerticalSpacing.s,
          // ageRange (dropdown)
          VerticalSpacing.s,
          // ethnicity (dropdown)
          VerticalSpacing.s,
          // sexuality (dropdown)
          VerticalSpacing.s,
          // disability (checkbox)
          VerticalSpacing.s,
          // married (checkbox)
          VerticalSpacing.s,
          // isParent (checkbox)
          VerticalSpacing.s,
          const TeamList(),
          VerticalSpacing.s,
          // terms and conditions (checkbox)
        ],
      ),
    );
  }
}

/// create a widget that says, "You have unsaved changes. click to ignore them."
/// when clicked, it will set the adminUserFormHasChangesProvider to false
Widget unsavedChanges(BuildContext context, WidgetRef ref) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.yellow[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.yellow[700]!, width: 2),
    ),
    child: GestureDetector(
      onTap: () {
        ref.read(adminUserFormHasChangesProvider.notifier).setHasChanges(false);
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('You have unsaved changes. Click to ignore them.'),
      ),
    ),
  );
}

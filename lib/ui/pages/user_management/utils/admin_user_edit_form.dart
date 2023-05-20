// Path: lib/ui/pages/user_management/utils/admin_user_edit_form.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/teams_list.dart';
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/ui/pages/user/profile_page_widgets/profile_page_widgets.dart';

class UserProfileForm extends ConsumerWidget {
  final UserProfile userProfile;
  final bool isAdmin;

  UserProfileForm({super.key, required this.userProfile, this.isAdmin = false});

  TextEditingController jobTitleController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userProfileNotifierProvider);
    final box = ref.watch(accessBoxProvider);

    void updateField(
        BuildContext context, WidgetRef ref, String field, dynamic value) {
      ref.read(userProfileNotifierProvider.notifier).updateField(field, value);
    }

    const borderRadius = BorderRadius.all(Radius.circular(16));
    return Form(
      child: Column(
        children: [
          email(userProfileState, borderRadius, updateField, context, ref,
              emailController),
          VerticalSpacing.s,
          jobTitle(userProfileState, borderRadius, updateField, context, ref,
              jobTitleController),
          VerticalSpacing.s,
          ageRange(userProfileState, borderRadius, updateField, context, ref),
          VerticalSpacing.s,
          ethnicity(userProfileState, borderRadius, updateField, context, ref),
          VerticalSpacing.s,
          sexuality(userProfileState, borderRadius, updateField, context, ref),
          VerticalSpacing.s,
          disability(userProfileState, updateField, context, ref),
          VerticalSpacing.s,
          married(userProfileState, updateField, context, ref),
          VerticalSpacing.s,
          isParent(userProfileState, updateField, context, ref),
          VerticalSpacing.s,
          const TeamList(),
          VerticalSpacing.s,
          terms(userProfileState, updateField, context, ref),
          VerticalSpacing.s,
          homeButton(ref),
          VerticalSpacing.s,
          logoutButton(box, ref),
          // isAdmin ? admin-specific fields : null,
        ],
      ),
    );
  }
}

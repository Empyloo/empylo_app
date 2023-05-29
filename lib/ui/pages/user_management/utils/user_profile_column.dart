import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/ui/molecules/widgets/teams_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/ui/pages/user/profile_page_widgets/profile_page_widgets.dart';

Column buildUserProfileColumn(
  BorderRadius borderRadius,
  void Function(
    BuildContext context,
    WidgetRef ref,
    String field,
    dynamic value,
    String? userId,
  ) updateField,
  BuildContext context,
  WidgetRef ref,
  TextEditingController emailController,
  TextEditingController jobTitleController,
  String? userId,
) {
  final userProfileState = ref.watch(userProfileNotifierProvider);
  final box = ref.watch(accessBoxProvider);
  return Column(
    children: [
      email(
        userProfileState!.email,
        borderRadius,
        updateField,
        context,
        ref,
        emailController,
        userId,
      ),
      VerticalSpacing.s,
      jobTitle(
        userProfileState.jobTitle,
        borderRadius,
        updateField,
        context,
        ref,
        jobTitleController,
        userId,
      ),
      VerticalSpacing.s,
      ageRange(
        userProfileState.ageRange,
        borderRadius,
        updateField,
        context,
        ref,
        userId,
      ),
      VerticalSpacing.s,
      ethnicity(
        userProfileState.ethnicity,
        borderRadius,
        updateField,
        context,
        ref,
        userId,
      ),
      VerticalSpacing.s,
      sexuality(
        userProfileState.sexuality,
        borderRadius,
        updateField,
        context,
        ref,
        userId,
      ),
      VerticalSpacing.s,
      disability(
        userProfileState.disability,
        updateField,
        context,
        ref,
        userId,
      ),
      VerticalSpacing.s,
      married(
        userProfileState.married,
        updateField,
        context,
        ref,
        userId,
      ),
      VerticalSpacing.s,
      isParent(
        userProfileState.isParent,
        updateField,
        context,
        ref,
        userId,
      ),
      VerticalSpacing.s,
      const TeamList(),
      VerticalSpacing.s,
      terms(
        userProfileState.acceptedTerms,
        updateField,
        context,
        ref,
        userId,
      ),
      VerticalSpacing.s,
      homeButton(ref),
      VerticalSpacing.s,
      logoutButton(box, ref),
    ],
  );
}

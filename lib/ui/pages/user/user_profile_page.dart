// Path: lib/ui/pages/user/user_profile_page.dart
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_access_checker_provider.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/ui/molecules/widgets/teams_list.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/ui/pages/user/profile_page_widgets/profile_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hasChangesProvider = StateProvider<bool>((ref) => false);

class UserProfilePage extends ConsumerWidget {
  UserProfilePage({super.key});

  // Adding TextEditingController for jobTitle and email
  final jobTitleController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // check viewer is authorized to view this page
    final userProfileState = ref.watch(userProfileNotifierProvider);

    final userId = userProfileState?.id;
    final isUserAuthorized =
        userId != null ? ref.watch(userAccessCheckerProvider(userId)) : false;

    if (userProfileState == null || !isUserAuthorized) {
      return const ErrorPage('You do not have permission to access this page.');
    }

    final hasChanges = ref.watch(hasChangesProvider);
    final box = ref.watch(accessBoxProvider);

    void updateField(BuildContext context, WidgetRef ref, String field,
        dynamic value, String? userId) {
      ref.read(userProfileNotifierProvider.notifier).updateField(field, value);
      ref.read(hasChangesProvider.notifier).state = true;
    }

    const borderRadius = BorderRadius.all(Radius.circular(16));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  email(userProfileState.email, borderRadius, updateField,
                      context, ref, emailController, userId),
                  VerticalSpacing.s,
                  jobTitle(userProfileState.jobTitle, borderRadius, updateField,
                      context, ref, jobTitleController, userId),
                  VerticalSpacing.s,
                  ageRange(userProfileState.ageRange, borderRadius, updateField,
                      context, ref, userId),
                  VerticalSpacing.s,
                  ethnicity(userProfileState.ethnicity, borderRadius,
                      updateField, context, ref, userId),
                  VerticalSpacing.s,
                  sexuality(userProfileState.sexuality, borderRadius,
                      updateField, context, ref, userId),
                  VerticalSpacing.s,
                  disability(userProfileState.disability, updateField, context,
                      ref, userId),
                  VerticalSpacing.s,
                  married(userProfileState.married, updateField, context, ref,
                      userId),
                  VerticalSpacing.s,
                  isParent(userProfileState.isParent, updateField, context, ref,
                      userId),
                  VerticalSpacing.s,
                  const TeamList(),
                  VerticalSpacing.s,
                  terms(userProfileState.acceptedTerms, updateField, context,
                      ref, userId),
                  VerticalSpacing.s,
                  homeButton(ref),
                  VerticalSpacing.s,
                  logoutButton(box, ref),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:
          hasChanges ? saveChangesButton(context, ref, userProfileState) : null,
    );
  }
}

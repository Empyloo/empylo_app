// Path: lib/ui/pages/user_management/admin_user_edit_page.dart
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_access_checker_provider.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/state_management/users/admin_edit_user_notifier.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/ui/molecules/widgets/teams_list.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/ui/pages/user/profile_page_widgets/admin_save_button.dart';
import 'package:empylo_app/ui/pages/user/profile_page_widgets/profile_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminHasChangesProvider = StateProvider<bool>((ref) => false);

class AdminUserEditPage extends ConsumerWidget {
  AdminUserEditPage({Key? key}) : super(key: key);

  // Adding TextEditingController for jobTitle and email
  final jobTitleController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // check viewer is authorized to view this page
    final currentUser = ref.watch(userProfileNotifierProvider);

    final userId = currentUser?.id;
    final isUserAuthorized =
        userId != null ? ref.watch(userAccessCheckerProvider(userId)) : false;

    if (currentUser == null || !isUserAuthorized) {
      return const ErrorPage('You do not have permission to access this page.');
    }

    final hasChanges = ref.watch(adminHasChangesProvider);
    final box = ref.watch(accessBoxProvider);
    final userBeingEdited = ref.watch(adminEditUserNotifierProvider);

    void updateField(BuildContext context, WidgetRef ref, String field,
        dynamic value, String? userId) {
      ref
          .read(adminEditUserNotifierProvider.notifier)
          .updateState({field: value});
      ref.read(adminHasChangesProvider.notifier).state = true;
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
                  email(userBeingEdited!.email, borderRadius, updateField,
                      context, ref, emailController, userId),
                  VerticalSpacing.s,
                  jobTitle(userBeingEdited.jobTitle, borderRadius, updateField,
                      context, ref, jobTitleController, userId),
                  VerticalSpacing.s,
                  ageRange(userBeingEdited.ageRange, borderRadius, updateField,
                      context, ref, userId),
                  VerticalSpacing.s,
                  ethnicity(userBeingEdited.ethnicity, borderRadius,
                      updateField, context, ref, userId),
                  VerticalSpacing.s,
                  sexuality(userBeingEdited.sexuality, borderRadius,
                      updateField, context, ref, userId),
                  VerticalSpacing.s,
                  disability(userBeingEdited.disability, updateField, context,
                      ref, userId),
                  VerticalSpacing.s,
                  married(userBeingEdited.married, updateField, context, ref,
                      userId),
                  VerticalSpacing.s,
                  isParent(userBeingEdited.isParent, updateField, context, ref,
                      userId),
                  VerticalSpacing.s,
                  const TeamList(),
                  VerticalSpacing.s,
                  terms(userBeingEdited.acceptedTerms, updateField, context,
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
      floatingActionButton: hasChanges
          ? adminSaveChangesButton(context, ref, userBeingEdited)
          : null,
    );
  }
}

// Path: lib/ui/pages/user_management/admin_user_edit_page.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/user_access_checker_provider.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:empylo_app/ui/pages/user_management/utils/admin_user_edit_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminUserEditPage extends ConsumerWidget {
  final UserProfile userProfile;

  const AdminUserEditPage({Key? key, required this.userProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // check if user is admin or super_admin
    final isUserAuthorized = ref.watch(userAccessCheckerProvider(userProfile.id));

    if (!isUserAuthorized) {
      return const ErrorPage('You do not have permission to access this page.');
    }

    final formHasChangesNotifier = ValueNotifier<bool>(false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User: ${userProfile.email}'),
      ),
      body: UserProfileForm(userProfile: userProfile, isAdmin: true),
    );
  }
}

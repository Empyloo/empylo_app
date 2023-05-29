// Path: lib/ui/pages/user_management/layouts/content.dart
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/state_management/users/admin_edit_user_notifier.dart';
import 'package:empylo_app/tokens/button_styles.dart';
import 'package:empylo_app/ui/pages/company_management/utils/on_delete_company.dart';
import 'package:empylo_app/utils/user_utils/get_user_profile_by_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildIdCopyButton(String id) {
  return TextButton.icon(
    icon: const Icon(Icons.content_copy),
    label: Text('ID: $id'),
    onPressed: () => Clipboard.setData(ClipboardData(text: id)),
    style: EmpyloButtonStyles.textPrimary,
  );
}

Widget buildEmailCopyButton(String email) {
  return TextButton.icon(
    icon: const Icon(Icons.content_copy),
    label: Text('Email: $email'),
    onPressed: () => Clipboard.setData(ClipboardData(text: email)),
    style: EmpyloButtonStyles.textPrimary,
  );
}

Widget buildGoToEditButton(String id, WidgetRef ref) {
  return SizedBox(
    child: OutlinedButton.icon(
      icon: const Icon(Icons.edit),
      label: const Text('Edit'),
      onPressed: () {
        final userProfile = getUserProfileByIdWidgetRef(ref, id);
        ref
            .read(adminEditUserNotifierProvider.notifier)
            .setUserProfile(userProfile!);
        ref.read(routerProvider).push('/admin-user-edit?id=$id');
      },
      style: EmpyloButtonStyles.outlinedPrimary,
    ),
  );
}

Widget buildDeleteButton(BuildContext context, String id, WidgetRef ref) {
  return SizedBox(
    child: OutlinedButton.icon(
      icon: const Icon(Icons.delete),
      label: const Text('Delete'),
      onPressed: () async {
        await onDeleteCompany(context, id, ref);
      },
      style: EmpyloButtonStyles.outlinedSecondary,
    ),
  );
}

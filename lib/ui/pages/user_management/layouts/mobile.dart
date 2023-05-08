// Path: lib/ui/pages/user_management/layouts/mobile.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/tokens/button_styles.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/pages/company_management/utils/on_delete_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileLayout extends StatelessWidget {
  final UserProfile userProfile;
  final WidgetRef ref;

  const MobileLayout({
    Key? key,
    required this.userProfile,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.content_copy),
            label: Text('ID: ${userProfile.id}'),
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: userProfile.id)),
            style: EmpyloButtonStyles.textPrimary,
          ),
          TextButton.icon(
            icon: const Icon(Icons.content_copy),
            label: Text('Email: ${userProfile.email}'),
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: userProfile.email)),
            style: EmpyloButtonStyles.textPrimary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  onPressed: () {
                    ref
                        .read(routerProvider)
                        .push('/user-profile?id=${userProfile.id}');
                  },
                  style: EmpyloButtonStyles.outlinedPrimary,
                ),
              ),
              const SizedBox(width: Sizes.s),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  onPressed: () async {
                    await onDeleteCompany(context, userProfile.id, ref);
                  },
                  style: EmpyloButtonStyles.outlinedSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Path: lib/ui/pages/company_management/layouts/desktop.dart
import 'package:empylo_app/state_management/routing/router_provider.dart';
import 'package:empylo_app/tokens/button_styles.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/pages/company_management/utils/on_delete_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesktopLayout extends StatelessWidget {
  final String id;
  final String email;
  final WidgetRef ref;

  const DesktopLayout({
    Key? key,
    required this.id,
    required this.email,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.content_copy),
          label: Text('ID: $id'),
          onPressed: () => Clipboard.setData(ClipboardData(text: id)),
          style: EmpyloButtonStyles.textPrimary,
        ),
        TextButton.icon(
          icon: const Icon(Icons.content_copy),
          label: Text('Email: $email'),
          onPressed: () => Clipboard.setData(ClipboardData(text: email)),
          style: EmpyloButtonStyles.textPrimary,
        ),
        SizedBox(
           width: Sizes.jumbo * 2 + Sizes.s,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: Sizes.jumbo,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  onPressed: () {
                    ref.read(routerProvider).push('/company-profile?id=$id');
                  },
                  style: EmpyloButtonStyles.outlinedPrimary,
                ),
              ),
              const SizedBox(width: Sizes.s),
              SizedBox(
                width: Sizes.jumbo,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  onPressed: () async {
                    await onDeleteCompany(context, id, ref);
                  },
                  style: EmpyloButtonStyles.outlinedSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

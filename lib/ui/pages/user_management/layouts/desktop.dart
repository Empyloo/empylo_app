// Path: lib/ui/pages/user_management/layouts/desktop.dart

import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/pages/user_management/layouts/content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesktopLayout extends StatelessWidget {
  final UserProfile userProfile;
  final WidgetRef ref;

  const DesktopLayout({
    Key? key,
    required this.userProfile,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildIdCopyButton(userProfile.id),
        buildEmailCopyButton(userProfile.email),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildGoToEditButton(userProfile.id, ref),
              const SizedBox(width: Sizes.s),
              buildDeleteButton(context, userProfile.id, ref),
            ],
          ),
        ),
      ],
    );
  }
}

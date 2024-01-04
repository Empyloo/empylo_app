// Path: lib/ui/pages/user_management/layouts/tablet.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/pages/user_management/layouts/content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabletLayout extends StatelessWidget {
  final UserProfile userProfile;
  final WidgetRef ref;

  const TabletLayout({
    super.key,
    required this.userProfile,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: buildIdCopyButton(userProfile.id),
        ),
        Expanded(
          flex: 3,
          child: buildEmailCopyButton(userProfile.email),
        ),
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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

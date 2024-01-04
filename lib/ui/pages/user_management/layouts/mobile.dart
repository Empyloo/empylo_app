// Path: lib/ui/pages/user_management/layouts/mobile.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/pages/user_management/layouts/content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileLayout extends StatelessWidget {
  final UserProfile userProfile;
  final WidgetRef ref;

  const MobileLayout({
    super.key,
    required this.userProfile,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildIdCopyButton(userProfile.id),
          buildEmailCopyButton(userProfile.email),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildGoToEditButton(userProfile.id, ref),
              ),
              const SizedBox(width: Sizes.s),
              Expanded(
                child: buildDeleteButton(context, userProfile.id, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Path: lib/ui/pages/user_management/layouts/mobile.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/tokens/button_styles.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/pages/company_management/utils/on_delete_company.dart';
import 'package:empylo_app/ui/pages/user_management/layouts/content.dart';
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

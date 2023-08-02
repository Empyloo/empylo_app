// Path: lib/ui/pages/user_management/user_management.dart
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:empylo_app/ui/pages/user_management/layouts/layouts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagement extends ConsumerWidget {
  const UserManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfiles = ref.watch(userProfilesListProvider);

    if (userProfiles.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final accessToken = await getAccessToken(ref);
        final userProfile = ref.watch(userProfileNotifierProvider);
        final userRole = ref.watch(authStateProvider);
        await ref.read(userProfilesListProvider.notifier).getUserProfiles(
            accessToken, userRole.role.name, userProfile!.companyID);
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Text(
          "User List",
          style:
              EmpyloTypography.caption.copyWith(color: ColorTokens.textLight),
        ),
        VerticalSpacing.m,
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isTabletLayout =
                constraints.maxWidth >= Breakpoints.tablet;
            final bool isDesktopLayout =
                constraints.maxWidth >= Breakpoints.desktop;

            return Column(
              children: List.generate(
                userProfiles.length,
                (index) {
                  UserProfile userProfile = userProfiles[index];

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: index % 2 == 0
                          ? Colors.grey.shade100
                          : Colors.blue.shade50,
                    ),
                    child: ListTile(
                      // title: Text(userProfile.name),
                      subtitle: isDesktopLayout
                          ? DesktopLayout(
                              userProfile: userProfile,
                              ref: ref,
                            )
                          : isTabletLayout
                              ? TabletLayout(
                                  userProfile: userProfile,
                                  ref: ref,
                                )
                              : MobileLayout(
                                  userProfile: userProfile,
                                  ref: ref,
                                ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

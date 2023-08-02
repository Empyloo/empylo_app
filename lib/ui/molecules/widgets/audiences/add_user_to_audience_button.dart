// Path: lib/ui/molecules/widgets/audiences/add_user_to_audience_button.dart
import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/models/audience_member.dart';
import 'package:empylo_app/models/user_audience_link.dart';
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/state_management/audiences/audience_users_list_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserToAudienceButton extends ConsumerWidget {
  final Audience? audience;

  const AddUserToAudienceButton({super.key, this.audience});

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

    return PopupMenuButton<UserProfile>(
      onSelected: (UserProfile userProfile) async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final accessToken = await getAccessToken(ref);
        final userAudienceLink = UserAudienceLink(
          audienceId: audience!.id!,
          userId: userProfile.id, // pass user ID instead of email
        );
        try {
          await ref.read(audienceUsersListProvider.notifier).addUser(
              audience!.id!,
              AudienceMember(audienceId: audience!.id!, email: userProfile.id),
              accessToken,
              userAudienceLink);
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('User added to audience successfully'),
            ),
          );
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Error adding user to audience: $e'),
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return userProfiles.map((UserProfile userProfile) {
          return PopupMenuItem<UserProfile>(
            value: userProfile,
            child: Text(userProfile.email), // display user email in menu
          );
        }).toList();
      },
    );
  }
}

// Path: lib/ui/molecules/widgets/audiences/audience_member_list.dart
import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/models/user_audience_link.dart';
import 'package:empylo_app/state_management/audiences/audience_users_list_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/state_management/users/user_profiles_list.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudienceMemberList extends ConsumerWidget {
  final Audience? audience;

  const AudienceMemberList({super.key, this.audience});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileNotifierProvider);

    return FutureBuilder(
      future: () async {
        final accessToken = await getAccessToken(ref);
        final userRole = ref.watch(authStateProvider);

        await ref.read(audienceUsersListProvider.notifier).getUsersInAudience(
            audience!.id!,
            accessToken,
            userRole.role.name,
            userProfile!.companyID);
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final audienceUsers = (audience != null && audience!.id != null)
              ? ref.watch(audienceUsersListProvider)[audience!.id!]
              : null;
          final userProfiles = ref.watch(userProfilesListProvider);

          if (audienceUsers == null || audienceUsers.isEmpty) {
            return const Center(child: Text('No users in this audience'));
          } else {
            final filteredAudienceUsers = audienceUsers.where((user) {
              return userProfiles.any((profile) => profile.email == user.email);
            }).toList();

            return SingleChildScrollView(
              child: Column(
                children: filteredAudienceUsers.map((user) {
                  final userProfile = userProfiles
                      .firstWhere((profile) => profile.email == user.email);

                  // If userProfile is null, it means no profile was found for this user.
                  // In such case, we return a zero-sized widget.
                  if (userProfile == null) return const SizedBox.shrink();

                  return ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              userProfile.email,
                              style: const TextStyle(
                                  fontSize: 14), // adjust the font size here
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              // Remove user from audience logic
                              final accessToken = await getAccessToken(ref);
                              final userAudienceLink = UserAudienceLink(
                                audienceId: audience!.id!,
                                userId: user.email,
                              );
                              try {
                                await ref
                                    .read(audienceUsersListProvider.notifier)
                                    .removeUser(
                                        audience!.id!,
                                        user,
                                        accessToken,
                                        userAudienceLink,
                                        userProfile.id);
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'User removed from audience successfully'),
                                  ),
                                );
                              } catch (e) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Error removing user from audience: $e'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        }
      },
    );
  }
}

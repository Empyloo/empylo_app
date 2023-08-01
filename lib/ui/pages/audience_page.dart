// Path: lib/ui/pages/audience_page.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/ui/molecules/widgets/audience_edit_modal.dart';
import 'package:empylo_app/state_management/audiences/audience_notifier.dart';
import 'package:empylo_app/utils/get_access_token.dart';

class AudiencePage extends ConsumerWidget {
  const AudiencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audienceList = ref.watch(audienceNotifierProvider);
    final userProfile = ref.watch(userProfileNotifierProvider);
    final authState = ref.watch(authStateProvider);

    if (audienceList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final accessToken = await getAccessToken(ref);

        // Fetch the audiences
        await ref.read(audienceNotifierProvider.notifier).getAudiences(
            userProfile!.companyID, accessToken, authState.role.name);
      });
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: audienceList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(audienceList[index].name),
            onTap: () => showDialog(
              context: context,
              builder: (context) => Dialog(
                child: AudienceEditModal(
                  audience: audienceList[index],
                  onAudienceEdited: (updatedAudience) async {
                    final accessToken = await getAccessToken(ref);
                    ref.read(audienceNotifierProvider.notifier).updateAudience(
                        userProfile!.companyID,
                        accessToken,
                        audienceList[index].id,
                        updatedAudience);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final accessToken = await getAccessToken(ref);
                ref.read(audienceNotifierProvider.notifier).deleteAudience(
                    userProfile!.companyID,
                    accessToken,
                    audienceList[index].id);
              },
            ),
          ),
        );
      },
    );
  }
}

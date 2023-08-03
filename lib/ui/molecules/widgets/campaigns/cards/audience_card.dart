import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/state_management/audiences/audience_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/audiences/audience_modal.dart';
import 'package:empylo_app/ui/pages/audience_page.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudienceCard extends ConsumerWidget {
  const AudienceCard({Key? key}) : super(key: key);

  Future<void> handleAudienceCreation(
      BuildContext context, WidgetRef ref, Audience audience) async {
    final userProfile = ref.watch(userProfileNotifierProvider);
    navPop() {
      Navigator.pop(context);
    } // close the dialog

    final accessToken = await getAccessToken(ref);
    await ref.read(audienceNotifierProvider.notifier).createAudience(
        userProfile!.id, userProfile.companyID, accessToken, audience);
    navPop(); // close the modal
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.blue[10],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Audiences",
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AudienceModal(
                        audience: null,
                        onAudienceEdited: (audience) =>
                            handleAudienceCreation(context, ref, audience),
                        type: 'create',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const AudiencePage(),
        ],
      ),
    );
  }
}

// Path: lib/ui/molecules/widgets/campaigns/campaigns.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/campaigns/campaign_list_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/dialogues/campaign_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Campaigns extends ConsumerWidget {
  final Function(String id, String name)? onCampaignSelected;

  const Campaigns({super.key, this.onCampaignSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: () async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final userRole = ref.watch(authStateProvider);
        final userProfile = ref.watch(userProfileNotifierProvider);
        try {
          await ref
              .read(campaignListNotifierProvider.notifier)
              .getCampaigns(ref, userProfile!.companyID, userRole.role.name);
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Error fetching campaigns: $e'),
            ),
          );
        }
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final campaigns = ref.watch(campaignListNotifierProvider);
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: campaigns.length,
            itemBuilder: (context, index) {
              final campaign = campaigns[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(campaign.name),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      try {
                        switch (value) {
                          case 'Edit':
                            showDialog(
                              context: context,
                              builder: (context) => CampaignDialog(
                                campaign: campaign,
                                onCampaignEdited: (editedCampaign) async {
                                  await ref
                                      .read(
                                          campaignListNotifierProvider.notifier)
                                      .updateCampaign(
                                          editedCampaign, ref);
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Campaign updated successfully'),
                                    ),
                                  );
                                },
                                type: 'edit',
                              ),
                            );
                            break;
                          case 'Delete':
                            final isDeleted = await ref
                                .read(campaignListNotifierProvider.notifier)
                                .deleteCampaign(campaign.id!, ref);
                            if (isDeleted) {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Campaign deleted successfully'),
                                ),
                              );
                            } else {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Error deleting campaign'),
                                ),
                              );
                            }
                            break;
                          case 'Select':
                            if (onCampaignSelected != null) {
                              onCampaignSelected!(campaign.id!, campaign.name);
                            }
                            break;
                        }
                      } catch (e) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text('Error processing action: $e'),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Select',
                        child: Text('Select'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

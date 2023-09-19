// Path: lib/ui/molecules/widgets/audiences/audience_menu.dart
import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/state_management/audiences/audience_notifier.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/utils/get_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudienceMenu extends ConsumerWidget {
  final TextEditingController controller;

  const AudienceMenu({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audienceListNotifier = ref.read(audienceNotifierProvider.notifier);
    final audiences = ref.watch(audienceNotifierProvider);
    final userProfile = ref.watch(userProfileNotifierProvider);
    final authState = ref.watch(authStateProvider);

    if (audiences.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final accessToken = await getAccessToken(ref);
        await audienceListNotifier.getAudiences(
            userProfile!.companyID, accessToken, authState.role.name);
      });
      return const CircularProgressIndicator();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Audience', style: TextStyle(fontWeight: FontWeight.bold)),
          Container(
            height: 60.0,
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: controller.text.isEmpty ? null : controller.text,
              onChanged: (value) {
                controller.text = value ?? '';
              },
              items:
                  audiences.map<DropdownMenuItem<String>>((Audience audience) {
                return DropdownMenuItem<String>(
                  value: audience.id,
                  child: Text(audience.name),
                );
              }).toList(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              isExpanded: true,
            ),
          ),
        ],
      );
    }
  }
}

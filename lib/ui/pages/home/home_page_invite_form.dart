// lib/ui/pages/home/home_page_invite_form.dart
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_invite_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageInviteForm extends ConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _emailsController = TextEditingController();
    final _organizationIdController = TextEditingController();
    final _organizationNameController = TextEditingController();

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailsController,
            decoration:
                const InputDecoration(labelText: 'Emails (comma separated)'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email(s)';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _organizationIdController,
            decoration:
                const InputDecoration(labelText: 'Organization ID (Optional)'),
          ),
          TextFormField(
            controller: _organizationNameController,
            decoration: const InputDecoration(
                labelText: 'Organization Name (Optional)'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final userInviteService = ref.read(userInviteServiceProvider);
                final accessToken = ref
                    .read(accessBoxProvider)
                    .asData!
                    .value
                    .get('session')['access_token'];
                final emails = _emailsController.text.split(',');
                final organizationId = _organizationIdController.text;
                final organizationName = _organizationNameController.text;

                try {
                  await userInviteService.invites(
                    emails: emails,
                    organizationId:
                        organizationId.isNotEmpty ? organizationId : null,
                    organizationName:
                        organizationName.isNotEmpty ? organizationName : null,
                    accessToken: accessToken,
                  );
                  showSnackBar('Invites sent successfully');
                } catch (e) {
                  print('Error sending invites: $e');
                  showSnackBar('Error sending invites');
                }
              }
            },
            child: const Text('Send Invites'),
          ),
        ],
      ),
    );
  }
}

// Path: lib/ui/molecules/widgets/audiences/audience_modal.dart
import 'package:empylo_app/ui/molecules/widgets/audiences/audience_form_fields.dart';
import 'package:empylo_app/ui/molecules/widgets/audiences/audience_member_list.dart';
import 'package:empylo_app/ui/molecules/widgets/audiences/add_user_to_audience_button.dart';
import 'package:empylo_app/ui/molecules/widgets/audiences/edit_or_create_audience.dart';
import 'package:empylo_app/utils/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/models/audience.dart';

typedef AudienceCallback = Function(Audience audience);

class AudienceModal extends ConsumerWidget {
  final Audience? audience;
  final AudienceCallback onAudienceEdited;
  final String type; // "create" or "edit"

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  AudienceModal({
    Key? key,
    required this.audience,
    required this.onAudienceEdited,
    required this.type,
  }) : super(key: key) {
    if (audience != null) {
      nameController.text = audience!.name;
      descriptionController.text = audience!.description ?? '';
      typeController.text = audience!.type;
    } else {
      typeController.text = 'all';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        width: 400,
        // height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Audience ${type.capitalizeFirst()}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            AudienceFormFields(
              nameController: nameController,
              descriptionController: descriptionController,
              typeController: typeController,
            ),
            const SizedBox(height: 16),
            // Always reserve the space for the audience count
            if (type == "edit" && audience != null)
              Text('Count: ${audience!.count}') // Display count here
            else
              Container(height: 16), // Empty container to maintain the height
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => editOrCreateAudience(
                context: context,
                ref: ref,
                nameController: nameController,
                descriptionController: descriptionController,
                type: type,
                audience: audience,
                onAudienceEdited: onAudienceEdited,
              ),
              child: Text('Submit ${type.capitalizeFirst()} Audience'),
            ),
            const SizedBox(height: 16),
            if (type == "edit" && audience != null && audience!.count! > 0)
              AudienceMemberList(audience: audience),
            AddUserToAudienceButton(audience: audience),
          ],
        ),
      ),
    );
  }
}

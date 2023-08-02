// Path: lib/ui/molecules/widgets/audiences/edit_or_create_audience.dart
import 'package:empylo_app/models/audience.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/audience_create_edit_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AudienceCallback = Function(Audience audience);

void editOrCreateAudience({
  required BuildContext context,
  required WidgetRef ref,
  required TextEditingController nameController,
  required TextEditingController descriptionController,
  required String type,
  required Audience? audience,
  required AudienceCallback onAudienceEdited,
}) async {
  final audienceName = nameController.text;
  final audienceDescription = descriptionController.text;
  final audienceType = ref.read(audienceTypeProvider);

  if (audienceName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a name for the audience.')),
    );
    return;
  }
  final userProfile = ref.read(userProfileNotifierProvider);
  final updatedAudience = Audience(
    id: audience?.id ?? '',
    name: audienceName,
    description: audienceDescription,
    count: audience?.count,
    type: audienceType,
    companyId: audience?.companyId ?? userProfile!.companyID,
    createdAt: audience?.createdAt ?? DateTime.now(),
    createdBy: audience?.createdBy ?? userProfile!.id,
  );

  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
    final successMessage = type == "edit" ? "edited" : "created";
    await onAudienceEdited(updatedAudience);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Audience $successMessage successfully'),
      ),
    );
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Failed to $type audience: $e'),
      ),
    );
  }
}

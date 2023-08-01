// Path: lib/ui/molecules/widgets/audience_edit_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/models/audience.dart';

typedef AudienceCallback = Function(Audience audience);

final audienceNameEditProvider = StateProvider<String>((ref) => '');
final audienceDescriptionEditProvider = StateProvider<String>((ref) => '');

class AudienceEditModal extends ConsumerWidget {
  final Audience audience;
  final AudienceCallback onAudienceEdited;

  const AudienceEditModal({
    Key? key,
    required this.audience,
    required this.onAudienceEdited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audienceName = ref.watch(audienceNameEditProvider);
    final audienceDescription = ref.watch(audienceDescriptionEditProvider);

    return Container(
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Edit Audience', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) =>
                ref.read(audienceNameEditProvider.notifier).state = value,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => ref
                .read(audienceDescriptionEditProvider.notifier)
                .state = value,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _editAudience(context, ref),
            child: const Text('Edit Audience'),
          ),
        ],
      ),
    );
  }

  void _editAudience(BuildContext context, WidgetRef ref) {
    final audienceName = ref.watch(audienceNameEditProvider);
    final audienceDescription = ref.watch(audienceDescriptionEditProvider);

    if (audienceName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name for the audience.')),
      );
      return;
    }

    final updatedAudience = Audience(
      id: audience.id,
      name: audienceName,
      description: audienceDescription,
      count: audience.count,
      type: audience.type,
      createdAt: audience.createdAt,
    );
    onAudienceEdited(updatedAudience);
  }
}

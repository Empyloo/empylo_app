// Path: lib/ui/molecules/widgets/audience_creation_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/models/audience.dart';

typedef AudienceCallback = Function(Audience audience);

final audienceNameProvider = StateProvider<String>((ref) => '');
final audienceDescriptionProvider = StateProvider<String>((ref) => '');

class AudienceCreationModal extends ConsumerWidget {
  final AudienceCallback onAudienceCreated;

  const AudienceCreationModal({super.key, required this.onAudienceCreated});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audienceName = ref.watch(audienceNameProvider);
    final audienceDescription = ref.watch(audienceDescriptionProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Create a new Audience', style: TextStyle(fontSize: 18)),
        TextField(
          onChanged: (value) =>
              ref.read(audienceNameProvider.notifier).state = value,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          onChanged: (value) =>
              ref.read(audienceDescriptionProvider.notifier).state = value,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        ElevatedButton(
          onPressed: () => _createAudience(context, ref),
          child: const Text('Create Audience'),
        ),
      ],
    );
  }

  void _createAudience(BuildContext context, WidgetRef ref) {
    final audienceName = ref.watch(audienceNameProvider);
    final audienceDescription = ref.watch(audienceDescriptionProvider);

    if (audienceName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name for the audience.')),
      );
      return;
    }

    final audience = Audience(
      id: '', // Generate an ID or let the backend handle it.
      name: audienceName,
      description: audienceDescription,
      count: 0,
      type: 'Custom',
      createdAt: DateTime.now(),
    );
    onAudienceCreated(audience);
  }
}

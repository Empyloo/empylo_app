// Path: lib/ui/molecules/widgets/audiences/audience_form_fields.dart
import 'package:empylo_app/ui/molecules/widgets/audience_create_edit_modal.dart';
import 'package:empylo_app/utils/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudienceFormFields extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController typeController;

  const AudienceFormFields({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.typeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        TextField(
          controller: nameController,
          onChanged: (value) =>
              ref.read(audienceNameProvider.notifier).state = value,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          onChanged: (value) =>
              ref.read(audienceDescriptionProvider.notifier).state = value,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButton<String>(
          value: ref.watch(audienceTypeProvider),
          onChanged: (value) =>
              ref.read(audienceTypeProvider.notifier).state = value ?? '',
          items: <String>['custom', 'all']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.capitalizeFirst()),
            );
          }).toList(),
        ),
      ],
    );
  }
}

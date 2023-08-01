// Path: lib/ui/molecules/widgets/campaigns/frequency_drop_down.dart
import 'package:flutter/material.dart';

class FrequencyDropdown extends StatelessWidget {
  final TextEditingController controller;

  const FrequencyDropdown({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const frequencyOptions = [
      'Daily',
      'Weekly',
      'Fortnightly',
      'Monthly',
      'Quarterly',
      'Annually',
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Frequency',
          border: OutlineInputBorder(),
        ),
        value: controller.text.isEmpty ? null : controller.text,
        onChanged: (value) {
          controller.text = value ?? 'Daily';
        },
        items:
            frequencyOptions.map<DropdownMenuItem<String>>((String frequency) {
          return DropdownMenuItem<String>(
            value: frequency,
            child: Text(frequency),
          );
        }).toList(),
      ),
    );
  }
}

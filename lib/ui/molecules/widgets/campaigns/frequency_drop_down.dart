// Path: lib/ui/molecules/widgets/campaigns/frequency_drop_down.dart
import 'package:empylo_app/utils/iterable_extensions.dart';
import 'package:flutter/material.dart';

String? getDatabaseValue(String? displayValue, Map<String, String> mapping) {
  return firstWhereOrNull(
    mapping.entries,
    (MapEntry<String, String> entry) => entry.value == displayValue,
  )?.key;
}

class FrequencyDropdown extends StatelessWidget {
  final TextEditingController controller;
  FrequencyDropdown({Key? key, required this.controller}) : super(key: key);

  final Map<String, String> frequencyMapping = {
    'daily': 'Daily',
    'weekly': 'Weekly',
    'fortnightly': 'Fortnightly',
    'monthly': 'Monthly',
    'quarterly': 'Quarterly',
    'annually': 'Annually',
  };

  @override
  Widget build(BuildContext context) {
    // Convert the database value to its display value
    final displayValue = frequencyMapping[controller.text] ?? 'Daily';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Frequency',
          border: OutlineInputBorder(),
        ),
        value: displayValue,
        onChanged: (selectedDisplayValue) {
          final dbValue =
              getDatabaseValue(selectedDisplayValue, frequencyMapping) ??
                  'daily'; // Default to 'daily' if not found
          controller.text = dbValue;
        },
        items: frequencyMapping.values
            .map<DropdownMenuItem<String>>((String frequency) {
          return DropdownMenuItem<String>(
            value: frequency,
            child: Text(frequency),
          );
        }).toList(),
      ),
    );
  }
}

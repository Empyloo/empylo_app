// Path: lib/ui/molecules/inputs/labelled_drop_downs.dart

import 'package:empylo_app/utils/text_extension.dart';
import 'package:flutter/material.dart';

class LabeledDropdown extends StatelessWidget {
  final TextEditingController controller;
  final List<String> items;
  final String labelText;
  final Function(dynamic)? onChanged;

  const LabeledDropdown({
    super.key,
    required this.controller,
    required this.items,
    required this.labelText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(
          value: controller.text.isEmpty ? null : controller.text,
          onChanged: (newValue) {
            controller.text = newValue!;
            if (onChanged != null) {
              onChanged!(newValue);
            }
          },
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item.capitalizeFirst()),
            );
          }).toList(),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

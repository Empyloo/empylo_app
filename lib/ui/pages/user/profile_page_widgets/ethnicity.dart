// Path: lib/
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EthnicityDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;

  const EthnicityDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Ethnicity',
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      items: <String>[
        'Asian',
        'Black',
        'White',
        'Mixed',
        'Other',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

SizedBox ethnicity(
  String? defaultValue,
  BorderRadius borderRadius,
  void Function(BuildContext context, WidgetRef ref, String field,
          dynamic value, String? userId)
      updateField,
  BuildContext context,
  WidgetRef ref,
  String? userId,
) {
  return SizedBox(
    width: Sizes.massive,
    height: Sizes.mega,
    child: EthnicityDropdown(
      value: defaultValue,
      onChanged: (String? newValue) {
        updateField(context, ref, 'ethnicity', newValue, userId);
      },
    ),
  );
}

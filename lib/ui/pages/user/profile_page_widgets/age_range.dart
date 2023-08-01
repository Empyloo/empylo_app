// Path: lib/ui/pages/profile_page_widgets/age_range.dart
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgeRangeDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;

  const AgeRangeDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Age Range',
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      ),
      items: <String>['16-25', '26-35', '36-45', '46-55', '56-65', '66+']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

SizedBox ageRange(
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
    height: Sizes.xxl,
    child: AgeRangeDropdown(
      value: defaultValue,
      onChanged: (String? newValue) {
        try {
          updateField(context, ref, 'age_range', newValue, userId);
          print('age_range: $newValue');
        } catch (e) {
          print(e);
        }
      },
    ),
  );
}

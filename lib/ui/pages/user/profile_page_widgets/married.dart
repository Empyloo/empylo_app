// Path: lib/ui/pages/profile_page_widgets/married.dart
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarriedCheckbox extends StatelessWidget {
  final bool? value;
  final void Function(bool?) onChanged;

  const MarriedCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Married'),
      value: value ?? false,
      onChanged: onChanged,
    );
  }
}

SizedBox married(
    bool? defaultValue,
    void Function(BuildContext context, WidgetRef ref, String field,
            dynamic value, String? userId)
        updateField,
    BuildContext context,
    WidgetRef ref,
    String? userId) {
  return SizedBox(
    width: Sizes.massive,
    height: Sizes.xxl,
    child: MarriedCheckbox(
      value: defaultValue,
      onChanged: (bool? newValue) {
        updateField(context, ref, 'married', newValue, userId);
      },
    ),
  );
}

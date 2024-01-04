// Path: lib/ui/pages/user/profile_page_widgets/disability.dart
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisabilityCheckbox extends StatelessWidget {
  final bool? value;
  final void Function(bool?) onChanged;

  const DisabilityCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Disability'),
      value: value ?? false,
      onChanged: onChanged,
    );
  }
}

SizedBox disability(
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
    child: DisabilityCheckbox(
      value: defaultValue,
      onChanged: (bool? newValue) {
        updateField(context, ref, 'disability', newValue, userId);
      },
    ),
  );
}

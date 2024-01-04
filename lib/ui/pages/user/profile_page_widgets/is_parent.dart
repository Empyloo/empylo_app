// Path: lib/ui/pages/user/profile_page_widgets/is_parent.dart
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsParentCheckbox extends StatelessWidget {
  final bool? value;
  final void Function(bool?) onChanged;

  const IsParentCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Is Parent'),
      value: value ?? false,
      onChanged: onChanged,
    );
  }
}

SizedBox isParent(
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
    child: IsParentCheckbox(
      value: defaultValue,
      onChanged: (bool? newValue) {
        updateField(context, ref, 'is_parent', newValue, userId);
      },
    ),
  );
}

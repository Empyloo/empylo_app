// Path: lib/ui/pages/user_management/utils/admin_user_edit_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobTitleField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const JobTitleField({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      onChanged: onChanged,
    );
  }
}

Widget jobTitle(
  String? defaultValue,
  BorderRadius borderRadius,
  void Function(BuildContext context, WidgetRef ref, String field,
          dynamic value, String? userId)
      updateField,
  BuildContext context,
  WidgetRef ref,
  TextEditingController controller,
  String? userId,
) {
  controller.text = defaultValue ?? '';
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  return JobTitleField(
    controller: controller,
    onChanged: (value) => updateField(context, ref, 'job_title', value, userId),
  );
}

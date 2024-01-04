// Path: lib/ui/pages/user_management/utils/admin_user_edit_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobTitleField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const JobTitleField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Job Title',
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        ),
        onChanged: onChanged,
      ),
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

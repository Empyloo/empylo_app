// Path:
import 'package:empylo_app/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TextFormField jobTitle(
    UserProfile? userProfileState,
    BorderRadius borderRadius,
    void Function(
            BuildContext context, WidgetRef ref, String field, dynamic value)
        updateField,
    BuildContext context,
    WidgetRef ref,
    TextEditingController controller) {
  controller.text = userProfileState?.jobTitle ?? '';
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.text,
    decoration: const InputDecoration(
      border: InputBorder.none,
    ),
    onChanged: (value) => updateField(context, ref, 'job_title', value),
  );
}

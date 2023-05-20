// Path:
import 'package:empylo_app/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TextFormField email(
    UserProfile? userProfileState,
    BorderRadius borderRadius,
    void Function(
            BuildContext context, WidgetRef ref, String field, dynamic value)
        updateField,
    BuildContext context,
    WidgetRef ref,
    TextEditingController controller) {
  controller.text = userProfileState?.email ?? '';
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      labelText: 'Email',
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    ),
    onChanged: (value) => updateField(context, ref, 'email', value),
  );
}

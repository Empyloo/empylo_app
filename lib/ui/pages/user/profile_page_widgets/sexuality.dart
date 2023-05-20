// Path:
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

SizedBox sexuality(
    UserProfile? userProfileState,
    BorderRadius borderRadius,
    void Function(
            BuildContext context, WidgetRef ref, String field, dynamic value)
        updateField,
    BuildContext context,
    WidgetRef ref) {
  return SizedBox(
    width: Sizes.massive,
    height: Sizes.xxl,
    child: DropdownButtonFormField<String>(
      value: userProfileState?.sexuality,
      decoration: InputDecoration(
        labelText: 'Sexuality',
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      items: <String>[
        'Heterosexual',
        'Homosexual',
        'Bisexual',
        'Pansexual',
        'Asexual',
        'Other',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        updateField(context, ref, 'sexuality', newValue);
      },
    ),
  );
}

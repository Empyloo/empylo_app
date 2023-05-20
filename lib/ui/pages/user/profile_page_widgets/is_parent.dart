// Path:
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

SizedBox isParent(
    UserProfile? userProfileState,
    void Function(
            BuildContext context, WidgetRef ref, String field, dynamic value)
        updateField,
    BuildContext context,
    WidgetRef ref) {
  return SizedBox(
    width: Sizes.massive,
    height: Sizes.xxl,
    child: CheckboxListTile(
      title: const Text('Is Parent'),
      value: userProfileState?.isParent ?? false,
      onChanged: (bool? newValue) {
        updateField(context, ref, 'is_parent', newValue);
      },
    ),
  );
}

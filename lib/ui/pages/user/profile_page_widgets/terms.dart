// Path:
import 'package:empylo_app/models/user_profile.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsCheckbox extends StatelessWidget {
  final bool? value;
  final void Function(bool?) onChanged;

  const TermsCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Accept Terms'),
      value: value ?? false,
      onChanged: onChanged,
    );
  }
}

SizedBox terms(
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
    child: TermsCheckbox(
      value: defaultValue,
      onChanged: (bool? newValue) {
        updateField(context, ref, 'accepted_terms', newValue, userId);
      },
    ),
  );
}

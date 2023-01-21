/*
This file contains all the checkboxes used in the app.
*/

// Path: lib/ui/molecules/inputs/checkboxes.dart
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/tokens/edge_inserts.dart';

class SimpleCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final EdgeInsetsGeometry padding;
  final double width;
  final Widget? label;
  final MainAxisAlignment rowMainAxisAlignment;

  const SimpleCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.padding = EmpyloEdgeInserts.s,
    this.width = Sizes.m,
    this.label,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: rowMainAxisAlignment,
      children: <Widget>[
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: Sizes.xs),
            child: label,
          ),
        ],
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

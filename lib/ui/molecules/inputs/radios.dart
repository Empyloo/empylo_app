/*
This file defines all the radio buttons used in the app. Import the colors.dart
file to get the colors, sizes.dart file to get the sizes, border_radius.dart
file to get the border radius and typography.dart to get the text styles.
*/

// Path: lib/ui/molecules/inputs/radios.dart
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';

class RadioInput extends StatelessWidget {
  final String label;
  final TextStyle? textStyle;
  final bool value;
  final void Function(bool?)? onChanged;
  final Color? backgroundColor;
  final BoxDecoration? containerDecoration;
  final EdgeInsetsGeometry margin;

  final double width;
  final double height;

  const RadioInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.textStyle,
    this.width = Sizes.huge,
    this.height = Sizes.xxl,
    this.containerDecoration,
    this.backgroundColor,
    this.margin = EmpyloEdgeInserts.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: containerDecoration,
      child: RadioListTile(
        value: value,
        groupValue: value,
        onChanged: onChanged,
        title: Text(label, style: textStyle),
      ),
    );
  }
}

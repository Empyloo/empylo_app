/*  This file defines a selection widget which is basically a
combination of a checkbox and another widget, could be text or an icon.
*/

// Path: lib/ui/molecules/inputs/selections.dart
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';

class Selection extends StatelessWidget {
  final Widget child;
  final bool value;
  final void Function(bool?)? onChanged;
  final Color? backgroundColor;
  final BoxDecoration? containerDecoration;
  final EdgeInsetsGeometry margin;

  final double width;
  final double height;

  const Selection({
    super.key,
    required this.child,
    required this.value,
    required this.onChanged,
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
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: child,
      ),
    );
  }
}

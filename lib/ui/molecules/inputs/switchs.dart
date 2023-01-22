/*
This file defines the switch widget used in the app. Import the colors.dart
file to get the colors, sizes.dart file to get the sizes, border_radius.dart
file to get the border radius and typography.dart to get the text styles.
Example: from flutter docs:
```
Switch(
  value: _lights,
  onChanged: (bool newValue) {
    setState(() {
      _lights = newValue;
    });
  },
)
```
In our case we use flutter_riverpod 2.0 to manage state,
but this focuses on the user interface.
*/

// Path: lib/ui/molecules/inputs/switches.dart
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';

class SwitchInput extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final Color? backgroundColor;
  final Color? activeColor;
  final BoxDecoration? containerDecoration;
  final EdgeInsetsGeometry margin;

  final double width;
  final double height;

  const SwitchInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = Sizes.huge,
    this.height = Sizes.xxl,
    this.containerDecoration,
    this.backgroundColor,
    this.activeColor,
    this.margin = EmpyloEdgeInserts.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: containerDecoration,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      ),
    );
  }
}

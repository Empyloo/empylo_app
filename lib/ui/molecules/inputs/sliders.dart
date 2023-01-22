/*
This file defines the silder widget used in the app. Import the colors.dart
file to get the colors, sizes.dart file to get the sizes, border_radius.dart
file to get the border radius and typography.dart to get the text styles.
Example: from flutter docs:
```
Slider(
  value: _duelCommandment.toDouble(),
  min: 1.0,
  max: 10.0,
  divisions: 2,
  label: '$question',
  onChanged: (double newValue) {
    print(newValue);
  },
)
```
In out case we use flutter_riverpod 2.0 to manage state,
but this focuses on the user interface.
*/

// Path: lib/ui/molecules/inputs/sliders.dart
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';

class SliderInput extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final void Function(double?)? onChanged;
  final Color? backgroundColor;
  final Color? activeColor;
  final BoxDecoration? containerDecoration;
  final EdgeInsetsGeometry margin;

  final double width;
  final double height;

  const SliderInput({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
    this.width = Sizes.massive,
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
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions.toInt(),
        label: label,
        onChanged: onChanged,
        activeColor: activeColor,
      ),
    );
  }
}

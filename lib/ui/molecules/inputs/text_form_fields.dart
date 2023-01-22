/*
This file defines the text form field widget used in the app. Import the colors.dart
file to get the colors, sizes.dart file to get the sizes, border_radius.dart
file to get the border radius and typography.dart to get the text styles.
Example: from flutter docs:
```
TextFormField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Enter your username',
  ),
  validator: (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  },
)
```
In our case we use flutter_riverpod 2.0 to manage state,
but this focuses on the user interface.
*/

// Path: lib/ui/molecules/inputs/text_form_fields.dart
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';

class TextFormFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final InputDecoration? decoration;
  final Function(String)? onSubmitted;
  final EdgeInsetsGeometry edgeInsetsGeo;
  final BoxDecoration? containerDecoration;
  final int maxLines;
  final double? height;
  final double width;
  final TextStyle? style;

  const TextFormFieldInput({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.edgeInsetsGeo,
    this.decoration,
    this.onSubmitted,
    this.containerDecoration,
    this.maxLines = 1,
    this.height = Sizes.xxl,
    this.style,
    this.width = Sizes.massive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: containerDecoration,
      margin: edgeInsetsGeo,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: decoration,
        onFieldSubmitted: onSubmitted,
        maxLines: maxLines,
        style: style,
      ),
    );
  }
}

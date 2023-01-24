/*
This file defines the text widget used in the app. Import the colors.dart
file to get the colors, sizes.dart file to get the sizes, border_radius.dart
file to get the border radius and typography.dart to get the text styles.
Example: from flutter docs:
```
SelectableText(
  'Hello, world!',
  textAlign: TextAlign.center,
  style: TextStyle(fontWeight: FontWeight.bold),
)
```
*/

// Path: lib/ui/molecules/text/text.dart
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';

class TextMolecule extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle? style;
  final EdgeInsetsGeometry edgeInsetsGeo;
  final BoxDecoration? containerDecoration;
  final double? height;
  final double width;
  final int maxLines;

  const TextMolecule({
    super.key,
    required this.text,
    required this.textAlign,
    this.style,
    this.edgeInsetsGeo = EmpyloEdgeInserts.s,
    this.containerDecoration,
    this.height = Sizes.xxl,
    this.width = Sizes.massive,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: containerDecoration,
      margin: edgeInsetsGeo,
      child: SelectableText(
        text,
        textAlign: textAlign,
        style: style,
        maxLines: maxLines,
      ),
    );
  }
}

class TextMoleculeImp extends StatelessWidget {
  const TextMoleculeImp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TextMolecule(
      text: 'Hello, world!',
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

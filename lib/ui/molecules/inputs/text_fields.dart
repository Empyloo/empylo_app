/* 
This file contains all the text fields used in the app.
*/

// Path: lib/ui/molecules/inputs/text_fields.dart
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/sizes.dart';

class SimpleTextField extends StatelessWidget {
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

  const SimpleTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.edgeInsetsGeo,
    this.decoration,
    this.onSubmitted,
    this.containerDecoration,
    this.maxLines = 1,
    this.height = Sizes.m,
    this.style,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: containerDecoration,
      margin: edgeInsetsGeo,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: decoration,
        onSubmitted: onSubmitted,
        maxLines: maxLines,
        style: style,
      ),
    );
  }
}

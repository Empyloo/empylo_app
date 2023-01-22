/*
This file defines all the file uploaders used in the app. Import the colors.dart
file to get the colors, sizes.dart file to get the sizes, border_radius.dart
file to get the border radius and typography.dart to get the text styles.
*/

// Path: lib/ui/molecules/inputs/file_uploaders.dart
import 'package:empylo_app/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/tokens/edge_inserts.dart';

class FileUpload extends StatelessWidget {
  final void Function() onPressed;
  final EdgeInsets margin;
  final double width;
  final double height;
  final String? fileName;
  final TextStyle textStyle;
  final Color? backgroundColor;
  final BoxDecoration? containerDecoration;
  final ButtonStyle? buttonStyle;

  const FileUpload({
    super.key,
    required this.onPressed,
    required this.textStyle,
    this.fileName,
    this.margin = EmpyloEdgeInserts.m,
    this.width = Sizes.huge,
    this.height = Sizes.xxl,
    this.backgroundColor = ColorTokens.background,
    this.containerDecoration,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    final String text = fileName != null ? "Upload $fileName" : "Upload File";
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: containerDecoration,
      child: TextButton.icon(
        style: buttonStyle,
        onPressed: onPressed,
        icon: const Icon(Icons.file_upload),
        label: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}

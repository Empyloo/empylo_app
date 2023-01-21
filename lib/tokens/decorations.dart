/*
This file contains all the decorations used in the app.
It imports the sizes.dart file to get the sizes, colors.dart file to get
the colors, border_radius.dart file to get the border radius and box_shadows.dart
file to get the box shadows.
*/

// Path: lib/tokens/box_decorations.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'sizes.dart';
import 'border_radius.dart';
import 'box_shadows.dart';

class EmpyloBoxDecorations {
  static const raised = BoxDecoration(
    color: ColorTokens.primary,
    borderRadius: EmpyloBorderRadius.s,
    boxShadow: [
      EmpyloBoxShadows.small,
    ],
  );

  static final roundedWithOutline = BoxDecoration(
    color: Colors.white,
    borderRadius: EmpyloBorderRadius.round,
    border: Border.all(
      color: ColorTokens.textDark,
      width: Sizes.xs,
    ),
  );

  static const roundedWithShadow = BoxDecoration(
    color: Colors.white,
    borderRadius: EmpyloBorderRadius.round,
    boxShadow: [
      EmpyloBoxShadows.small,
    ],
  );

  static final lightOutlined = BoxDecoration(
    border: Border.all(
      color: ColorTokens.textLight,
    ),
    borderRadius: EmpyloBorderRadius.m,
  );

  static final outlinedWithShadow = BoxDecoration(
    border: Border.all(
      color: ColorTokens.textDark,
      width: Sizes.xs,
    ),
    borderRadius: EmpyloBorderRadius.m,
    boxShadow: const [
      EmpyloBoxShadows.small,
    ],
  );
}

class EmpyloInputDecorations {
  static InputDecoration simpleRounded = const InputDecoration(
    border: OutlineInputBorder(
      borderRadius: EmpyloBorderRadius.m,
      borderSide: BorderSide.none,
    ),
  );
}

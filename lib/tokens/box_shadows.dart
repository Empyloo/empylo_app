/*
This file defines all the box shadows used in the app.
Import the colors.dart file to get the colors, sizes.dart file to get the sizes
and border_radius.dart file to get the border radius.
*/

// Path: lib/tokens/box_shadows.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'sizes.dart';

class EmpyloBoxShadows {
  static const raised = BoxShadow(
    color: ColorTokens.primaryDark,
    offset: Offset(0, Sizes.s),
    blurRadius: Sizes.m,
    spreadRadius: Sizes.xs,
  );
  static const small = BoxShadow(
    color: ColorTokens.textLight,
    offset: Offset(Sizes.xs, Sizes.xs),
    blurRadius: Sizes.xs,
  );

  static const medium = BoxShadow(
    color: ColorTokens.textLight,
    offset: Offset(Sizes.s, Sizes.xs),
    blurRadius: Sizes.m,
  );

  static const large = BoxShadow(
    color: ColorTokens.textDark,
    offset: Offset(0, Sizes.m),
    blurRadius: Sizes.l,
  );
}

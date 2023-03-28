/*
This file defines all the button styles used in the app.
Import the colors.dart file to get the colors, sizes.dart file to get the sizes,
border_radius.dart file to get the border radius and typography.dart to get the text styles.
*/

// Path: lib/tokens/button_styles.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'edge_inserts.dart';
import 'typography.dart';
import 'border_radius.dart';

class EmpyloButtonStyles {
  static final outlinedPrimary = OutlinedButton.styleFrom(
    foregroundColor: ColorTokens.primary,
    textStyle: EmpyloTypography.body.copyWith(color: ColorTokens.primary),
    padding: EmpyloEdgeInsertsSymmetric.m,
    shape: const RoundedRectangleBorder(borderRadius: EmpyloBorderRadius.l),
  );

  static final outlinedSecondary = OutlinedButton.styleFrom(
    foregroundColor: ColorTokens.secondary,
    textStyle: EmpyloTypography.body.copyWith(color: ColorTokens.secondary),
    padding: EmpyloEdgeInsertsSymmetric.m,
    shape: const RoundedRectangleBorder(borderRadius: EmpyloBorderRadius.l),
  );

  static final elevatedPrimary = ElevatedButton.styleFrom(
    foregroundColor: ColorTokens.primary,
    textStyle: EmpyloTypography.body.copyWith(color: ColorTokens.textLight),
    padding: EmpyloEdgeInsertsSymmetric.m,
    shape: const RoundedRectangleBorder(borderRadius: EmpyloBorderRadius.l),
  );

  static final elevatedSecondary = ElevatedButton.styleFrom(
    foregroundColor: ColorTokens.secondary,
    textStyle: EmpyloTypography.body.copyWith(color: ColorTokens.textLight),
    padding: EmpyloEdgeInsertsSymmetric.m,
    shape: const RoundedRectangleBorder(borderRadius: EmpyloBorderRadius.l),
  );

  static final textPrimary = TextButton.styleFrom(
    foregroundColor: ColorTokens.primary,
    textStyle: EmpyloTypography.body.copyWith(color: ColorTokens.primary),
    padding: EmpyloEdgeInsertsSymmetric.m,
    shape: const RoundedRectangleBorder(borderRadius: EmpyloBorderRadius.l),
  );

  static final textSecondary = TextButton.styleFrom(
    foregroundColor: ColorTokens.secondary,
    textStyle: EmpyloTypography.body.copyWith(color: ColorTokens.secondary),
    padding: EmpyloEdgeInsertsSymmetric.m,
    shape: const RoundedRectangleBorder(borderRadius: EmpyloBorderRadius.l),
  );

  // hover and focus styles
  static final hover = ButtonStyle(
    foregroundColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return ColorTokens.error.withOpacity(ColorTokens.xs);
      }
      return ColorTokens.secondaryDark;
    }),
  );
}

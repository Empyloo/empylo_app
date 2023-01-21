/*
This file contains all the typography used in the app.
We use the sizes.dart file to get the sizes, 
and the colors.dart file to get the colors.
For font families, we use Google Fonts.
 */

// Path: lib/tokens/typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'sizes.dart';

class EmpyloTypography {
  static final h1 = GoogleFonts.roboto(
    textStyle: const TextStyle(
      fontSize: Sizes.xxl,
      color: ColorTokens.textDark,
      fontWeight: FontWeight.w700,
    ),
  );

  static final h2 = GoogleFonts.roboto(
    textStyle: const TextStyle(
      fontSize: Sizes.xl,
      color: ColorTokens.textDark,
      fontWeight: FontWeight.w700,
    ),
  );

  static final caption = GoogleFonts.roboto(
    textStyle: const TextStyle(
      fontSize: Sizes.m,
      color: ColorTokens.textDark,
      fontWeight: FontWeight.w400,
    ),
  );

  static final body = GoogleFonts.roboto(
    textStyle: const TextStyle(
      fontSize: Sizes.m,
      color: ColorTokens.textDark,
      fontWeight: FontWeight.w400,
    ),
  );
}

/* Example of how to use the responsive typography
Text(
  'Example Text',
  style: Typography.h1.copyWith(
    fontSize: MediaQuery.of(context).size.width > Breakpoints.tablet ? Sizes.xxl : Sizes.xl
  ),
),
*/
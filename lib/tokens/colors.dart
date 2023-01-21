/* 
  This file contains all the colors used in the app.
*/
// Path: lib/tokens/colors.dart
import 'package:flutter/material.dart';

class ColorTokens {
  static const background = Color(0xFFFFFFFF); // white
  static const primary = Color(0xFFF1C4F7); // pink lace
  static const primaryLight = Color(0xFFF9E8F4); // pink frost
  static const primaryDark = Color(0xFFE085A9); // deep blush
  static const secondary = Color(0xFF00BFA5); // green sea
  static const secondaryLight = Color(0xFF5DF9D7); // aqua haze
  static const secondaryDark = Color(0xFF009688); // teal
  static const text = Color(0xFF212121); // black
  static const textLight = Color(0xFF9E9E9E); // grey
  static const textDark = Color(0xFF212121); // dark grey
  static const onPrimary = Color(0xFFFFFFFF); // white
  static const onSecondary = Color(0xFFFFFFFF); // white
  static const success = Color(0xFF34A853); // green
  static const error = Color(0xFFEA4335); // red

  static const elegantGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
  static const vibrantGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, secondaryLight],
  );

  static const softBlushGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const softGreenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

}

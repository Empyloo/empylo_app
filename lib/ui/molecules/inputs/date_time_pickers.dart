/*
This file contains all the date time pickers used in the app.
It imports the sizes.dart file to get the sizes, colors.dart file to get
the colors, border_radius.dart file to get the border radius and box_shadows.dart
file to get the box shadows, decorations.dart file to get the box decorations.
edge_inserts.dart file to get the edge inserts and typography.dart file for the
font styles.
*/

// Path: lib/ui/molecules/inputs/date_time_pickers.dart
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';

class SimpleDateTimePicker extends StatelessWidget {
  final DateTime initialDate;
  final void Function(DateTime) onDateTimeChanged;
  final EdgeInsetsGeometry margin;
  final double width;
  final double height;
  final Widget? label;
  final MainAxisAlignment rowMainAxisAlignment;
  final Color? backgroundColor;
  final BoxDecoration? containerDecoration;
  final TextStyle? textStyle;
  final String text;

  const SimpleDateTimePicker({
    super.key,
    required this.initialDate,
    required this.onDateTimeChanged,
    this.margin = EmpyloEdgeInserts.s,
    this.width = Sizes.m,
    this.label,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.backgroundColor = ColorTokens.background,
    this.containerDecoration,
    this.textStyle,
    this.height = Sizes.m,
    this.text = 'Select Date',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: containerDecoration,
      margin: margin,
      child: TextButton(
        onPressed: () async {
          DateTime now = DateTime.now();
          DateTime oneMonthFromNow = DateTime(now.year, now.month + 1);
          DateTime oneHunderedYearsAgo =
              DateTime(now.year - 100, now.month, now.day);
          final DateTime? date = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: oneHunderedYearsAgo,
            lastDate: oneMonthFromNow,
          );
          if (date != null) {
            onDateTimeChanged(date);
          }
        },
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}

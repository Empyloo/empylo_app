import 'package:empylo_app/tokens/border_radius.dart';
import 'package:empylo_app/tokens/box_shadows.dart';
import 'package:empylo_app/tokens/decorations.dart';
import 'package:empylo_app/ui/molecules/inputs/checkboxes.dart';
import 'package:empylo_app/ui/molecules/inputs/date_time_pickers.dart';
import 'package:empylo_app/ui/molecules/inputs/file_uploaders.dart';
import 'package:empylo_app/ui/molecules/inputs/radios.dart';
import 'package:empylo_app/ui/molecules/inputs/selections.dart';
import 'package:empylo_app/ui/molecules/inputs/sliders.dart';
import 'package:empylo_app/ui/molecules/inputs/switchs.dart';
import 'package:empylo_app/ui/molecules/inputs/text_fields.dart';
import 'package:empylo_app/utils/impl/text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:empylo_app/tokens/sizes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Empylo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Empylo',
            style: EmpyloTypography.body.copyWith(
                color: ColorTokens.textDark, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: ColorTokens.background,
        ),
        body: Center(
          child: Container(),
        ),
      ),
    );
  }
}

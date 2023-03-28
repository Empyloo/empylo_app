
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
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

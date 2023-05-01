// Path: lib/main.dart
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('session');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Empylo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2C3E50), // Dark blue
      ),
      routerConfig: ref.read(routerProvider),
    );
  }
}

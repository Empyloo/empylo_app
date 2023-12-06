// Path:
import 'package:empylo_app/state_management/routing/router_provider.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

SizedBox homeButton(WidgetRef ref) {
  return SizedBox(
    width: Sizes.massive,
    height: Sizes.xxl,
    child: TextButton(
      onPressed: () {
        ref.read(routerProvider).go('/home');
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue.withOpacity(0.7),
      ),
      child: const Text('Go to Home Page'),
    ),
  );
}

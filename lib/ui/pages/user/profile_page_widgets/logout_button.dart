// Path:
import 'package:empylo_app/state_management/routing/router_provider.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

SizedBox logoutButton(AsyncValue<dynamic> box, WidgetRef ref) {
  return SizedBox(
    width: Sizes.massive,
    height: Sizes.xxl,
    child: ElevatedButton(
      onPressed: () {
        // remove session from Hive box
        box.asData!.value.delete('session');
        // navigate to login page
        ref.read(routerProvider).go('/');
      },
      child: const Text('Logout'),
    ),
  );
}

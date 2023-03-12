// Path: lib/ui/pages/home/home_page.dart
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../state_management/user_provider.dart';
import '../../../state_management/access_box_provider.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final box = ref.watch(accessBoxProvider);

    if (box == null || box.asData == null) {
      router.go('/');
      return const SizedBox.shrink();
    }

    final storedToken = box as Box<String>;

    if (storedToken == null) {
      router.go('/');
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome user'),
            ElevatedButton(
              onPressed: () {
                // remove token from Hive box
                storedToken.delete('userSession');
                // navigate to login page
                router.go('/');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

// Path: lib/ui/pages/home/home_page.dart
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state_management/access_box_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final box = ref.watch(accessBoxProvider);

    if (box.asData == null) {
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
                // remove session from Hive box
                box.asData!.value.delete('session');
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

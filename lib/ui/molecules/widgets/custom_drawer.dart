import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/state_management/routing/router_provider.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final box = ref.watch(accessBoxProvider);

    return Drawer(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.translucent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Pages'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                router.go('/home');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                router.go('/user-profile');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // remove session from Hive box
                box.asData!.value.delete('session');
                // navigate to login page
                router.go('/');
                Navigator.pop(context);
              },
            ),
            // Add more ListTile for each route
          ],
        ),
      ),
    );
  }
}

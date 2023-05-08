// Path: lib/ui/pages/home/home_page.dart
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/state_management/user_profile_provider.dart';
import 'package:empylo_app/tokens/spacing.dart';
import 'package:empylo_app/ui/pages/company_management/super_admin_company_list.dart';
import 'package:empylo_app/ui/pages/user_management/user_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state_management/access_box_provider.dart';
import 'home_page_invite_form.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final box = ref.watch(accessBoxProvider);
    final authState = ref.watch(authStateProvider);
    final userProfile = ref.watch(userProfileNotifierProvider);
    const borderRadius = BorderRadius.all(Radius.circular(16));

    if (box.asData == null) {
      router.go('/');
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Welcome!'),
              VerticalSpacing.s,
              ElevatedButton(
                onPressed: () {
                  final String userId = userProfile!.id;
                  // navigate to profile page
                  router.go('/user-profile?id=$userId');
                },
                child: const Text('Go to Profile'),
              ),
              VerticalSpacing.s,
              ElevatedButton(
                onPressed: () {
                  // remove session from Hive box
                  box.asData!.value.delete('session');
                  // navigate to login page
                  router.go('/');
                },
                child: const Text('Logout'),
              ),
              if (authState.role == UserRole.admin ||
                  authState.role == UserRole.superAdmin)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: HomePageInviteForm(),
                    ),
                  ),
                ),
              VerticalSpacing.m,
              if (authState.role == UserRole.superAdmin)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: SuperAdminCompanyList(),
                    ),
                  ),
                ),
              VerticalSpacing.m,
              if (authState.role == UserRole.admin ||
                  authState.role == UserRole.superAdmin)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: UserManagement(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

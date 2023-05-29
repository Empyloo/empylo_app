import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/ui/molecules/widgets/custom_drawer.dart';
import 'package:empylo_app/ui/pages/company_management/super_admin_company_list.dart';
import 'package:empylo_app/ui/pages/dashboard/dash.dart';
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

    if (box.asData == null) {
      router.go('/');
      return const SizedBox.shrink();
    }

    return DefaultTabController(
      length: 4, // Adjust the number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          bottom: TabBar(
            tabs: [
              const Tab(icon: Icon(Icons.dashboard), text: "Dashboard"),
              if (authState.role == UserRole.admin ||
                  authState.role == UserRole.superAdmin)
                const Tab(icon: Icon(Icons.person_add), text: "Invite"),
              if (authState.role == UserRole.superAdmin)
                const Tab(icon: Icon(Icons.business), text: "Companies"),
              if (authState.role == UserRole.admin ||
                  authState.role == UserRole.superAdmin)
                const Tab(icon: Icon(Icons.people), text: "Users"),
            ],
          ),
        ),
        drawer: const CustomDrawer(),
        body: TabBarView(
          children: [
            // Add 'Dashboard' page here
            if (authState.role == UserRole.admin ||
                authState.role == UserRole.superAdmin)
              const DashboardPage(),
            // Add functionality of 'Invite' button here
            if (authState.role == UserRole.admin ||
                authState.role == UserRole.superAdmin)
              HomePageInviteForm(),
            // Add 'Company List' page here
            if (authState.role == UserRole.superAdmin)
              const SuperAdminCompanyList(),
            // Add 'User Management' page here
            if (authState.role == UserRole.admin ||
                authState.role == UserRole.superAdmin)
              const UserManagement(),
          ],
        ),
      ),
    );
  }
}

// path: lib/build_atoms_main.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/tokens/decorations.dart';
import 'package:empylo_app/tokens/edge_inserts.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/molecules/inputs/text_form_fields.dart';
import 'package:empylo_app/ui/molecules/widgets/companies_drop_down.dart';
import 'package:empylo_app/ui/pages/home/home_page_invite_form.dart';
import 'package:empylo_app/utils/get_user_role.dart';
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/example_credentials.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'ui/pages/company_management/super_admin_company_list.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('session');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Empylo',
      theme: ThemeData(useMaterial3: true),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

Future<bool> login({
  required String email,
  required String password,
  required WidgetRef ref,
}) async {
  try {
    final httpClient = ref.read(httpClientProvider);
    final response = await httpClient.post(
      url: '$remoteBaseUrl/auth/v1/token?grant_type=password',
      headers: {
        'Content-Type': 'application/json',
        'apikey': remoteAnonKey,
      },
      data: {
        'email': email,
        'password': password,
      },
    );
    final accessBox = await ref.read(accessBoxProvider.future);
    accessBox.put('session', response.data);
    UserRole userRole = getUserRoleFromResponse(response.data);
    ref.read(authStateProvider.notifier).login(userRole);
    // print("response.data: ${response.data}");
    return true;
  } catch (e) {
    print("Error during login!: $e");
    return false;
  }
}

class ShowPage extends ConsumerWidget {
  const ShowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return FutureBuilder<bool>(
            future: login(
              email: m_user,
              password: m_password,
              ref: ref,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data == true) {
                  return const Padding(
                    padding: EmpyloEdgeInserts.s,
                    child: SuperAdminCompanyList(),
                  );
                } else {
                  return const Text('Login failed');
                }
              } else {
                return const Text('Unknown error');
              }
            },
          );
        },
      ),
    );
  }
}

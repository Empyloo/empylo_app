// path: lib/build_atoms_main.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/tokens/decorations.dart';
import 'package:empylo_app/tokens/sizes.dart';
import 'package:empylo_app/ui/molecules/inputs/text_form_fields.dart';
import 'package:empylo_app/ui/pages/home/home_page_invite_form.dart';
import 'package:empylo_app/utils/get_user_role.dart';
import 'package:flutter/material.dart';
import 'package:empylo_app/tokens/colors.dart';
import 'package:empylo_app/tokens/typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/example_credentials.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('session');
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
        body: const Center(
          child: ShowPage(),
        ),
      ),
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
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return FutureBuilder<bool>(
          future: login(
            email: m_user,
            password: m_password,
            ref: ref,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data == true) {
                return Column(
                  children: [
                    TextFormFieldInput(
                      controller: TextEditingController(text: "email"),
                      keyboardType: TextInputType.emailAddress,
                      edgeInsetsGeo: const EdgeInsets.symmetric(vertical: 1.0),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                      ),
                      onSubmitted: (value) =>
                          print("onSubmitted: ${value.toString()}"),
                    ),
                    SizedBox(
                      width: Sizes.massive,
                      height: Sizes.xxl,
                      child: DropdownButtonFormField<String>(
                        value: "16-25",
                        decoration: InputDecoration(
                          labelText: 'Age Range',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                        ),
                        items: <String>[
                          '16-25',
                          '26-35',
                          '36-45',
                          '46-55',
                          '56-65',
                          '66+'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          print("newValue: $newValue");
                        },
                      ),
                    )
                  ],
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
    );
  }
}

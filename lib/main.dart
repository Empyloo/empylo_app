// Path: lib/main.dart
import 'package:empylo_app/models/session.dart';
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<Map<String, dynamic>>('session');
  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessBox = ref.watch(accessBoxProvider);
    // router provide to be able to check the url for a token
    final router = ref.watch(routerProvider);
    return accessBox.when(
      data: (box) {
        final userSession = box.get('session');
        if (userSession == null) {
          // check the url for an access_token
          final uriFragment = Uri.decodeFull(Uri.base.fragment).replaceAll('#', '?');
          print('uriFragment: $uriFragment');
          final token = Uri.parse(uriFragment).queryParameters['access_token'];
          print('Uri token: $token');
          // if there is a token, try to validate it
          if (token != null) {
            // Validate the token using UserNotifier
            ref
                .read(userProvider.notifier)
                .validateToken(accessToken: token, ref: ref)
                .then((isValid) {
              if (isValid) {
                // Redirect to home page if valid
                ref.read(routerProvider).go('/home');
              }
            });
          }
          // if there is no session and no access token, redirect the user to the login page
          ref.read(routerProvider).go('/login');
        } else {
          // if there is a session, try to validate the access token
          final accessBox = ref.watch(accessBoxProvider);
          final userSession = accessBox.when(
            data: (box) {
              // get access token from box
              final session = box.get('session');
              // validate the access token
              ref
                  .read(userProvider.notifier)
                  .validateToken(
                      accessToken: session!['access_token'], ref: ref)
                  .then((isValid) {
                if (isValid) {
                  // Redirect to home page if valid
                  ref.read(routerProvider).go('/home');
                } else {
                  // if the token is not valid, redirect to login page
                  ref.read(routerProvider).go('/login');
                }
              });
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => null,
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Empylo',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF2C3E50),
          ),
          routerConfig: ref.watch(routerProvider),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => ErrorPage(error),
    );
  }
}

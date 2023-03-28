// Path: lib/main.dart
import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/user_provider.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('session');
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

  Future<void> _handleTokenValidation({
    required String? accessToken,
    required String? refreshToken,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    if (accessToken != null && refreshToken != null) {
      // Validate the token using UserNotifier
      await ref.read(userProvider.notifier).validateToken(
          accessToken: accessToken,
          refreshToken: refreshToken,
          ref: ref,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessBox = ref.watch(accessBoxProvider);

    return accessBox.when(
      data: (box) {
        final dynamic userSession = box.get('session');

        if (userSession == null) {
          // Check the URL for access_token and refresh_token
          final uriFragment =
              Uri.decodeFull(Uri.base.fragment).replaceAll('#', '?');
          final queryParams = Uri.parse(uriFragment).queryParameters;
          final accessToken = queryParams['access_token'];
          final refreshToken = queryParams['refresh_token'];

          // If there are tokens, try to validate them
          _handleTokenValidation(
            accessToken: accessToken,
            refreshToken: refreshToken,
            ref: ref,
            context: context,
          );
        } else {
          // Get access token and refresh token from the existing userSession
          final accessToken = userSession['access_token'];
          final refreshToken = userSession['refresh_token'];

          // Validate the access token and refresh token
          _handleTokenValidation(
            accessToken: accessToken,
            refreshToken: refreshToken,
            ref: ref,
            context: context,
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Empylo',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF2C3E50), // Dark blue
          ),
          routerConfig: ref.watch(routerProvider),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => ErrorPage(error),
    );
  }
}

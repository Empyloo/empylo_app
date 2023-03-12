import 'package:empylo_app/state_management/router_provider.dart';
import 'package:empylo_app/services/go_true_token_client.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/ui/pages/error/erro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../state_management/user_provider.dart';

const String remoteBaseUrl = 'https://fzfsoqhwjvaymlwbcppi.supabase.co';
const String remoteAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6ZnNvcWh3anZheW1sd2JjcHBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjQ3MzA0MTksImV4cCI6MTk4MDMwNjQxOX0.AGE2xVNKAY64g8tX2r53ksJRumzRBV7Y7LZvFeWBxzk';

class LoginPage extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessBox = ref.watch(accessBoxProvider);

    return accessBox.when(
      data: (box) {
        final userSession = box.get('session');

        if (userSession != null) {
          ref.read(routerProvider).go('/home');
        }

        final user = ref.watch(userProvider.notifier);
        final screenWidth = MediaQuery.of(context).size.width;
        const borderRadius = BorderRadius.all(Radius.circular(16));
        const gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFe9f3f5), Color(0xFFf3f8f9)],
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              width: screenWidth * 0.8,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: const OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      user.login(
                        email: _emailController.text,
                        password: _passwordController.text,
                        ref: ref,
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: borderRadius,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blue.shade500,
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => ErrorPage(error),
    );
  }
}

// get url from browser address bar
String getUrl() {
  final url = Uri.base.toString();
  final index = url.indexOf('#');
  return index == -1 ? url : url.substring(0, index);
}

# empylo_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## flutter Commands

`flutter run -d chrome`
`flutter pub upgrade`
`flutter pub outdated`
`flutter pub upgrade --major-versions`
## Testing

`http://localhost:49296/#access_token=1235`

you are, sacha an expert senior software engineer, who write efficient flutter apps. you are working on a new project for a client. the client wants you to build a flutter app that will allow users to login and logout. the app will have a login page and a home page. the home page will be protected and only a logged in user should be able to access it. the app will use hive for caching and storing the user's session. the app will use riverpod for state management. the app will use go_router for routing. the app will use the atomic design pattern for the ui. the app will use the responsive design pattern for the ui.
the application implements multifactor authentiaction, so on 1st login the user should register with authantication app like google authenticator, then the user should be able to login.
using flutter v3_flutter riverpod 2.0, hive, go_router show the skeleton of a flutter application that only has a login page and all other pages are protected/gaurded. use go router redirect or any other prefered method to protect all other pages. only a logged in user should get access to protected routes. there should be an auth state notifier and the auth provider for it and there should also be the router and the router provider for it. the hive box is there to store the user's session once logged in, help with caching. separate the the code suggestions by file, add the file path at the start of each file like `// Path: main.dart` please make the code as efficient possible. imagen there's already a  user notifier,
here's the user notifiers stripped down code:

```dart
class UserNotifier extends StateNotifier<AsyncValue<User>> {
  final HttpClient _httpClient;
  final SentryService _sentry;

  UserNotifier(httpClient, sentry)
      : _httpClient = httpClient,
        _sentry = sentry,
        super(const AsyncValue.loading());

  Future<void> login({
    required String email,
    required String password,
    required String baseUrl,
    required String anonKey,
    required WidgetRef ref,
  }) async {
    try {
      print('Logging in...');
    }
    }
  Future<void> logout({
    required String accessToken,
    required String baseUrl,
  }) async {
    try {
        print('Logging out...');
        }
  }
}
```

create design elements using the atomic design patter. the design will allow us to reuse the elements, make the ui
responsive, changing layouts and colors easily. create a
class to easily manage responsiveness. define very subtle
opque colors and define size, spacing, and radius constants
that a re multiples of 8. the pages will use the providers

- layout everything that needs doing in the readme.md file
- create a design system
- detail each step of the app and how to achieve it and test

// Path: main.dart
- when the application starts, check if the user is logged in or not
- if the user is logged in, redirect to the home page
- if the user is not logged in, redirect to the login page
- the check should be done using the hive box, if the user is logged in, the hive box will have the user's session and an access token the should be validated before redirecting to the home page.
- sometimes the user's will be redirected and will have an access token in the 
url, so after checking the hive box, check the url for an access token and validate it before redirecting to the home page.
- we already have a user notifier, so we will use it to validate the access token
- we also have providers for the router, the user notifier, and the hive box
```dart
// Path: lib/state_management/auth_state_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthStateNotifier extends StateNotifier<bool> {
  AuthStateNotifier() : super(false);

  void login() {
    state = true;
  }

  void logout() {
    state = false;
  }
}

// Create a provider for the AuthStateNotifier
final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  return AuthStateNotifier();
});


// Path: lib/state_management/access_box_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Define a provider for Hive box that stores access tokens
final accessBoxProvider = FutureProvider<Box<String>>((ref) async {
  // Get the existing box named 'userSession'
  return Hive.box<String>('userSession');
});

// Path: lib/state_management/user_provider.dart
import 'package:empylo_app/state_management/http_client_provider.dart';
import 'package:empylo_app/state_management/sentry_service_provider.dart';
import 'package:empylo_app/state_management/user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_data.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<User>>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final sentry = ref.watch(sentryServiceProvider);
  return UserNotifier(httpClient, sentry);
});



```
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

- `flutter pub upgrade` or `flutter upgrade --force`
- `flutter pub outdated`
- `flutter pub upgrade --major-versions`
- `flutter run -d chrome`

### Build for web
`flutter build web`

### Target a start File
- Go to the [router_provider](ib/services/router_provider.dart) file and uncomment the line that has the `dev_main.dart` file.
- In that same file `builder: (context, state) => const ShowPage(), //const LoginPage(),` swap the `ShowPage()` with `LoginPage()`
- Run the command
`flutter run -d chrome -t lib/dev_main.dart`

<br>

**When finished, comment out the line again.**

## Testing
https://app.empylo.com/#/set-password#error=unauthorized_client&error_code=401&error_description=Email+link+is+invalid+or+has+expired
`http://localhost:49296/#/#access_token=1235&refresh_token=asdf&token_type=bearer&expires_in=3600`


### Dart experiments

Use this to experiment with dart code, services, etc.
`dart experiments_cred.dart`

### Debugging Flutter Errors

`rm -rf /Users/brianmusonza/development/flutter/bin/cache`
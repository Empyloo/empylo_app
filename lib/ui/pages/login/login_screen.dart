// // In login_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../models/user_data.dart';
// import '../../../state_management/user_provider.dart';

// class LoginScreen extends ConsumerWidget {
//   // Define text editing controllers for email and password fields
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Get the current value of the user provider
//     final userState = ref.watch(userProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Empylo'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Show a text field for email input
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               // Show a text field for password input
//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               // Show a button to login
//               ElevatedButton(
//                 onPressed: userState is AsyncValueLoading<User>
//                     ? null
//                     : () async {
//                         // Call login method on notifier when button is pressed
//                         await ref.read(userProvider.notifier).login(
//                               emailController.text,
//                               passwordController.text,
//                               baseUrl:
//                                   'https://example.com', // Replace with your base url
//                               anonKey:
//                                   'abcde', // Replace with your anonymous api key
//                             );
//                       },
//                 child: userState is AsyncValueLoading<User>
//                     ? CircularProgressIndicator()
//                     : Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

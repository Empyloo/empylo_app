// Path: lib/ui/pages/error/erro_page.dart
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage(this.error, {Key? key}) : super(key: key);

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong'),
            SelectableText(error.toString()),
          ],
        ),
      ),
    );
  }
}


// class ErrorPage extends StatelessWidget {
//   const ErrorPage(this.error, {Key? key}) : super(key: key);

//   final Object error;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Error')),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.purple,
//               Colors.blue,
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Path: ${ModalRoute.of(context)?.settings.name}',
//                   style: TextStyle(fontSize: 18.0, color: Colors.white)),
//               SizedBox(height: 16.0),
//               Icon(Icons.error_outline, size: 48.0, color: Colors.white),
//               SizedBox(height: 16.0),
//               Text('Something went wrong',
//                   style: TextStyle(fontSize: 24.0, color: Colors.white)),
//               SizedBox(height: 8.0),
//               SelectableText(error.toString(),
//                   style: TextStyle(fontSize: 18.0, color: Colors.white)),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () => Navigator.of(context).pushNamed('/login'),
//                 child: Text('Go to Login', style: TextStyle(fontSize: 18.0)),
//                 style: ElevatedButton.styleFrom(primary: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

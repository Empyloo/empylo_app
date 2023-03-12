import 'package:flutter/material.dart';

class MFAPage extends StatelessWidget {
  const MFAPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background shapes with blending gradients
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.purple.withOpacity(0.2),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: MediaQuery.of(context).size.width * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.pinkAccent.withOpacity(0.1),
                    Colors.deepPurple.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightBlue.withOpacity(0.2),
                    Colors.lightGreen.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          // Input box and submit button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 32,
            right: 32,
            child: Column(
              children: [
                const SizedBox(
                  height: 64,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Path: lib/ui/pages/login/pass_reset_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordResetPage extends ConsumerWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController textController = TextEditingController();
    const double textBoxWidth = 300;
    const double textBoxHeight = 50;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade100, Colors.orange.shade100],
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7)
                ]),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: textBoxWidth,
                      child: TextFormField(
                          controller: textController,
                          decoration: const InputDecoration(
                              hintText: 'Enter your email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          })),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Submit form
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(textBoxWidth, textBoxHeight)),
                      child: const Text('Submit'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

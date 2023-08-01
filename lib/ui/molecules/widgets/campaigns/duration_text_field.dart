// Path: lib/ui/molecules/widgets/campaigns/duration_text_field.dart
import 'package:flutter/material.dart';

class DurationTextField extends StatelessWidget {
  final TextEditingController controller;

  const DurationTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Duration',
          helperText: 'Enter duration (e.g., 5m, 1h, 1d, 2w, 1M)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a duration';
          }
          final regex = RegExp(r'^(\d+)(m|h|d|w|M)$');
          if (!regex.hasMatch(value)) {
            return 'Invalid format. Use 5m, 1h, 1d, 2w, 1M';
          }
          return null;
        },
      ),
    );
  }
}

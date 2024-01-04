// Path: lib/ui/molecules/widgets/campaigns/date_picker_text_field.dart
import 'package:flutter/material.dart';

class DatePickerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const DatePickerTextField(
      {super.key, required this.controller, required this.labelText});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: controller.text.isNotEmpty
            ? DateTime.parse(controller.text)
            : DateTime.now(),
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        (controller.text.isEmpty ||
            picked != DateTime.parse(controller.text))) {
      controller.text = picked.toIso8601String().split('T')[0];
    }
  }

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
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onTap: () {
          _selectDate(context);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a date';
          }
          return null;
        },
      ),
    );
  }
}

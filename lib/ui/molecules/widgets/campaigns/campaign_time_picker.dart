// Path: lib/ui/molecules/widgets/campaigns/campaign_time_picker.dart
import 'package:flutter/material.dart';

class TimePickerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const TimePickerTextField(
      {super.key, required this.controller, required this.labelText});

  Future<void> _selectTime(BuildContext context) async {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: controller.text.isNotEmpty
          ? TimeOfDay(
              hour: int.parse(controller.text.split(':')[0]),
              minute: int.parse(controller.text.split(':')[1]),
            )
          : TimeOfDay.now(),
    );
    if (picked != null &&
        (controller.text.isEmpty ||
            localizations.formatTimeOfDay(picked) != controller.text)) {
      controller.text = localizations.formatTimeOfDay(picked);
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
          _selectTime(context);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a time';
          }
          return null;
        },
      ),
    );
  }
}

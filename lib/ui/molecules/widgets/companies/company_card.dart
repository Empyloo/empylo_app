// Path: lib/ui/molecules/widgets/companies/company_card.dart
import 'package:empylo_app/models/company.dart';
import 'package:flutter/material.dart';


class CompanyCard extends StatelessWidget {
  final Company company;
  final VoidCallback onEdit;

  const CompanyCard({required this.company, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${company.name}'),
          Text('Email: ${company.email}'),
          Text('Phone: ${company.phone}'),
          Text('Size: ${company.size}'),
          // Add more company details here
          ElevatedButton(
            onPressed: onEdit,
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

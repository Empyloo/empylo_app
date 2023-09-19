// Path: lib/ui/molecules/widgets/companies/company_drop_down.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/state_management/selected_company_provider.dart';
import 'package:empylo_app/utils/company_fetcher.dart';
import 'package:empylo_app/utils/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyMenu extends ConsumerWidget {
  // Changed to ConsumerWidget
  final TextEditingController controller;
  final String labelText = "Company";

  const CompanyMenu({Key? key, required this.controller}) : super(key: key);

  void _selectCompany(BuildContext context, WidgetRef ref, String companyId) {
    final companies = ref.read(companyListNotifierProvider);
    final matchingCompany =
        firstWhereOrNull(companies, (company) => company.id == companyId);

    if (matchingCompany != null) {
      Future(() {
        ref
            .read(selectedCompanyProvider.notifier)
            .selectCompany(matchingCompany);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No matching company found for ID: $companyId')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef
    final companyFetcher =
        CompanyFetcher(ref); // Corrected to use CompanyFetcher
    final companies = ref.watch(companyListNotifierProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);

    companyFetcher.fetchCompaniesIfNeeded(companies);

    final companyId = controller.text;
    if (companyId.isNotEmpty && selectedCompany == null) {
      _selectCompany(context, ref, companyId);
    }

    final selectedCompanyText = selectedCompany == null
        ? 'Select a company'
        : 'Selected company is: ${selectedCompany.name}';
    // Rest of the code

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          margin: const EdgeInsets.only(top: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Company>(
              value: selectedCompany,
              onChanged: (company) {
                controller.text = company!.id!;
                ref
                    .read(selectedCompanyProvider.notifier)
                    .selectCompany(company);
              },
              hint: Text(selectedCompanyText),
              items: companies.map((Company company) {
                return DropdownMenuItem<Company>(
                  value: company,
                  child: Text(company.name),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

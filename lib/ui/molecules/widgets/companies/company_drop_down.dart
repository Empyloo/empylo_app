// Path: lib/ui/molecules/widgets/companies/company_drop_down.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/state_management/selected_company_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyMenu extends ConsumerWidget {
  final TextEditingController controller;

  const CompanyMenu({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyListNotifier = ref.read(companyListNotifierProvider.notifier);
    final companies = ref.watch(companyListNotifierProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);

    if (companies.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await companyListNotifier.fetchCompanies(ref);
      });
      return const CircularProgressIndicator();
    } else {
      final selectedCompanyText = selectedCompany == null
          ? 'Select a company'
          : 'Selected company is: ' + selectedCompany.name;

      return Container(
        height: 60.0,
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey, width: 1.0), // Changed border color to gray
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(selectedCompanyText),
              const SizedBox(width: 8),
              PopupMenuButton<Company>(
                onSelected: (company) {
                  controller.text = company.id!;
                  ref
                      .read(selectedCompanyProvider.notifier)
                      .selectCompany(company);
                },
                itemBuilder: (context) {
                  return companies
                      .map(
                        (company) => PopupMenuItem(
                          value: company,
                          child: Text(company.name),
                        ),
                      )
                      .toList();
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}

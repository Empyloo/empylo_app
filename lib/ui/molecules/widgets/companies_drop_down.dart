// Path: lib/ui/molecules/widgets/companies_drop_down.dart
import 'package:empylo_app/models/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';

class CompaniesDropDown extends ConsumerWidget {
  final Function(String?) onCompanySelected;

  const CompaniesDropDown({Key? key, required this.onCompanySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Company>> companiesAsyncValue =
        ref.watch(companyListNotifierProvider);

    String? selectedCompanyId;
    String? selectedCompanyName;

    return companiesAsyncValue.when(
      data: (companyList) {
        if (companyList.isEmpty) {
          return const Text('No companies found');
        }

        return DropdownButtonFormField<String>(
          value: selectedCompanyId,
          items: companyList
              .map((company) => DropdownMenuItem<String>(
                    value: company.id,
                    child: Text(company.name),
                  ))
              .toList(),
          onChanged: (String? companyId) {
            if (companyId != null) {
              selectedCompanyId = companyId;
              final selectedCompany =
                  companyList.firstWhere((company) => company.id == companyId);
              selectedCompanyName = selectedCompany.name;
              onCompanySelected(companyId);
            }
          },
          decoration: InputDecoration(
            labelText: 'Select a company',
            hintText: selectedCompanyName ?? 'Select a company',
            border: InputBorder.none,
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        // Handle error: show error message to user
        print('Error fetching companies: $error');
        return const Text('Error fetching companies');
      },
    );
  }
}

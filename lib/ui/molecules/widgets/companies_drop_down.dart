// Path: lib/ui/molecules/widgets/companies_drop_down.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/tokens/border_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';

class CompaniesDropDown extends ConsumerWidget {
  final Function(Company?) onCompanySelected;

  const CompaniesDropDown({super.key, required this.onCompanySelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Company> companyList = ref.watch(companyListNotifierProvider);

    String? selectedCompanyId;
    String? selectedCompanyName;

    // Check if the companyList is empty, which means the data is not fetched yet
    if (companyList.isEmpty) {
      // Fetch companies and rebuild the widget
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(companyListNotifierProvider.notifier)
            .fetchCompanies(ref);
      });

      // Show a loading spinner
      return const CircularProgressIndicator();
    } else {
      // onSuccess: Show companies list
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
            onCompanySelected(selectedCompany);
          }
        },
        decoration: InputDecoration(
          labelText: 'Select a company',
          hintText: selectedCompanyName ?? 'Select a company',
          border: const OutlineInputBorder(
            borderRadius: EmpyloBorderRadius.s,
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        ),
      );
    }
  }
}

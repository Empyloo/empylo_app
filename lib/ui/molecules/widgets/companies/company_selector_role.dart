// Path: lib/ui/molecules/widgets/companies/company_selector_role.dart
import 'package:empylo_app/models/company.dart';
import 'package:flutter/material.dart';

class CompanySelectorRow extends StatelessWidget {
  final String? selectedCompanyId;
  final List<Company> companyList;
  final Function(String?) onCompanySelected;

  const CompanySelectorRow({
    super.key,
    required this.selectedCompanyId,
    required this.companyList,
    required this.onCompanySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(selectedCompanyId == null ? 'Select a company' : 'Selected:'),
        const SizedBox(width: 8),
        if (selectedCompanyId == null)
          PopupMenuButton<String>(
            onSelected: (value) => onCompanySelected(value),
            itemBuilder: (context) => companyList
                .map((company) => PopupMenuItem<String>(
                      value: company.id,
                      child: Text(company.name),
                    ))
                .toList(),
          ),
        if (selectedCompanyId != null)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(companyList
                    .firstWhere((company) => company.id == selectedCompanyId)
                    .name),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => onCompanySelected(null),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

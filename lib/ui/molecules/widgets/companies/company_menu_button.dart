import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/utils/company_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localSelectedCompanyIdProvider = StateProvider<String?>((ref) => null);

class CompanyMenuButton extends ConsumerWidget {
  final List<Company> companyList;
  final Function(String? companyId) onCompanySelected;
  final String? selectedCompanyId;
  final bool isEditMode;

  const CompanyMenuButton({
    super.key,
    required this.companyList,
    required this.onCompanySelected,
    this.selectedCompanyId,
    this.isEditMode = false,
  });

  String getCompanyName(String id) {
    for (var company in companyList) {
      if (company.id == id) {
        return company.name;
      }
    }
    return 'Unknown Company';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyFetcher = CompanyFetcher(ref);
    companyFetcher.fetchCompaniesIfNeeded(companyList).then((success) {
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching companies')),
        );
      }
    });

    final localSelectedCompanyId = ref.watch(localSelectedCompanyIdProvider);

    String getButtonText() {
      final idToUse = localSelectedCompanyId ?? selectedCompanyId;
      if (isEditMode) {
        return idToUse != null
            ? 'Selected: ${getCompanyName(idToUse)}'
            : 'Created by: Unknown Company';
      } else {
        return idToUse != null
            ? 'Selected: ${getCompanyName(idToUse)}'
            : 'Add Company';
      }
    }

    return TextButton.icon(
      icon: const Icon(Icons.edit),
      label: Text(getButtonText()),
      onPressed: () {
        final renderBox = context.findRenderObject() as RenderBox?;
        final offset = renderBox?.localToGlobal(Offset.zero);
        showMenu(
          context: context,
          position: RelativeRect.fromRect(
            offset! & renderBox!.size,
            Offset.zero & MediaQuery.of(context).size,
          ),
          items: List.generate(companyList.length, (index) {
            final company = companyList[index];
            return PopupMenuItem(
              value: company.id,
              onTap: () {
                ref.read(localSelectedCompanyIdProvider.notifier).state = company.id;
                onCompanySelected(company.id);
              },
              child: Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.business),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(company.name),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

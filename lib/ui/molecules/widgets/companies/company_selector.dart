// Path: lib/ui/molecules/widgets/companies/company_selector.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/state_management/auth_state_notifier.dart';
import 'package:empylo_app/ui/molecules/widgets/companies/company_menu_button.dart';
import 'package:empylo_app/ui/molecules/widgets/field_contatiner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider is added because the widget doesn't debuild when companyId in
// the questionFormState changes to null (when delete is pressed),
// we believe this is to do with, when state goes from having a value
// to null, the widgets watching that state don't identify it as a change.
final selectedCompanyIdProvider = StateProvider<String?>((ref) => null);

class CompanySelector extends ConsumerWidget {
  final UserRole role;
  final List<Company> companyList;
  final bool isEditMode;
  final Function(String? companyId) onCompanySelected;
  final String? selectedCompanyId;

  const CompanySelector({
    super.key,
    required this.role,
    required this.companyList,
    required this.isEditMode,
    required this.onCompanySelected,
    this.selectedCompanyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (role != UserRole.superAdmin) return const SizedBox.shrink();

    return buildFieldContainer(
      child: CompanyMenuButton(
        companyList: companyList,
        onCompanySelected: (companyId) {
          if (companyId == null) {
            // handle adding a new company
            ref.read(selectedCompanyIdProvider.notifier).state = null;
            onCompanySelected(null);
          } else {
            // handle editing a company
            ref.read(selectedCompanyIdProvider.notifier).state = companyId;
            onCompanySelected(companyId);
          }
        },
        selectedCompanyId:
            selectedCompanyId ?? ref.read(selectedCompanyIdProvider),
        isEditMode: isEditMode,
      ),
    );
  }
}

// Path: lib/state_management/selected_company_provider.dart
import 'package:empylo_app/models/company.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCompanyProvider =
    StateNotifierProvider<SelectedCompanyNotifier, Company?>((ref) {
  return SelectedCompanyNotifier(null);
});

class SelectedCompanyNotifier extends StateNotifier<Company?> {
  SelectedCompanyNotifier(Company? company) : super(company);

  void selectCompany(Company? company) {
    state = company;
  }
}

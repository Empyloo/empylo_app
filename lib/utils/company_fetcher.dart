import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/state_management/selected_company_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyFetcher {
  final WidgetRef ref;

  CompanyFetcher(this.ref);

  Future<bool> fetchCompaniesIfNeeded(List<Company> companyList) async {
    if (companyList.isEmpty) {
      ref.read(selectedCompanyIdProvider.notifier).state = null;
      return await ref
          .read(companyListNotifierProvider.notifier)
          .fetchCompanies(ref);
    }
    return true;
  }
}

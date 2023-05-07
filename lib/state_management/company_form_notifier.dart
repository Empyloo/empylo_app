import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/services/company_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/company_list_provider.dart';
import 'package:empylo_app/state_management/company_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyFormNotifier extends StateNotifier<Company> {
  final CompanyService companyService;

  CompanyFormNotifier(this.companyService)
      : super(Company(
          id: '',
          name: '',
          email: '',
          size: 0,
          phone: '',
          description: '',
          subscribed: false,
        ));

  Future<String> getAccessToken(WidgetRef ref) async {
    final accessBox = await ref.watch(accessBoxProvider.future);
    return accessBox.get('session')['access_token'];
  }

  Future<bool> saveCompany(Company company, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      final updatedCompany = await companyService.updateCompany(
          accessToken, company.id!, company.toJson());
      state = updatedCompany;
      return true;
    } catch (e) {
      return false;
    }
  }
}

final companyFormNotifierProvider =
    StateNotifierProvider<CompanyFormNotifier, Company>(
  (ref) {
    // Get an instance of CompanyService from another provider
    final companyService = ref.watch(companyServiceProvider);

    // Return a new CompanyFormNotifier with the companyService and initialCompany
    return CompanyFormNotifier(companyService);
  },
);

final companyFormChangedProvider = StateProvider<bool>((ref) => false);

// In the providers.dart file
final companyProvider = Provider.family<Company, String>((ref, companyId) {
  final companyList = ref.watch(companyListNotifierProvider);
  return companyList.firstWhere((company) => company.id == companyId);
});

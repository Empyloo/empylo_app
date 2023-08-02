// Path: lib/state_management/company_list_provider.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/services/company_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/company_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyListNotifier extends StateNotifier<List<Company>> {
  final CompanyService companyService;

  CompanyListNotifier(this.companyService) : super([]);

  Future<String> getAccessToken(WidgetRef ref) async {
    final accessBox = await ref.watch(accessBoxProvider.future);
    return accessBox.get('session')['access_token'];
  }

  Future<bool> fetchCompanies(WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      final companies = await companyService.getCompanies(accessToken);
      state = companies;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createCompany(Map<String, dynamic> data, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      final company = await companyService.createCompany(
          accessToken, Company.fromJson(data));
      state = [...state, company];
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCompany(
      String id, Map<String, dynamic> data, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      final updatedCompany =
          await companyService.updateCompany(accessToken, id, data);
      state = [
        for (final company in state)
          if (company.id == id) updatedCompany else company
      ];
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteCompany(String id, WidgetRef ref) async {
    try {
      final accessToken = await getAccessToken(ref);
      await companyService.deleteCompany(accessToken, id);
      state = state.where((company) => company.id != id).toList();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final companyListNotifierProvider =
    StateNotifierProvider<CompanyListNotifier, List<Company>>((ref) {
  final companyService = ref.watch(companyServiceProvider);
  return CompanyListNotifier(companyService);
});

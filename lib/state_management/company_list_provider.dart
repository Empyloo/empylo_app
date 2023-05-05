// Path: lib/state_management/company_list_provider.dart
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/services/company_service.dart';
import 'package:empylo_app/state_management/access_box_provider.dart';
import 'package:empylo_app/state_management/company_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyListNotifier extends StateNotifier<List<Company>> {
  final CompanyService _companyService;

  CompanyListNotifier(this._companyService) : super([]);

  Future<void> fetchCompanies(WidgetRef ref) async {
    try {
      final accessBoxFuture = ref.watch(accessBoxProvider.future);
      final box = await accessBoxFuture;
      final accessToken = box.get('session')['access_token'];
      final companies = await _companyService.getCompanies(accessToken);
      state = companies;
    } catch (e) {
      // Handle error: show error message to user
      print('Error fetching companies: $e');
    }
  }
}

// final companyListNotifierProvider =
//     StateNotifierProvider<CompanyListNotifier, List<Company>>((ref) {
//   final companyService = ref.watch(companyServiceProvider);
//   return CompanyListNotifier(companyService);
// });


final companyListNotifierProvider = FutureProvider<List<Company>>((ref) async {
  final companyService = ref.watch(companyServiceProvider);
  final accessBox = await ref.watch(accessBoxProvider.future);
  final accessToken = accessBox.get('session')['access_token'];
  return companyService.getCompanies(accessToken);
});


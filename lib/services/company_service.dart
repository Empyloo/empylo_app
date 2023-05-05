// Path: lib/services/company_service.dart
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/company.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';

class CompanyService {
  final HttpClient _client;
  final SentryService _sentry;

  CompanyService({required HttpClient client, required SentryService sentry})
      : _client = client,
        _sentry = sentry;

  Future<List<Company>> getCompanies(String accessToken) async {
    try {
      final response = await _client.get(
        url: '$remoteBaseUrl/rest/v1/companies',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      print("Comp Service response: ${response.data}");
      return response.data
          .map<Company>((company) => Company.fromJson(company))
          .toList();
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching companies',
          level: 'error',
          extra: {'context': 'CompanyService.getCompanies', 'error': e},
        ),
      );
      rethrow;
    }
  }

  // Add other CRUD methods as needed (create, update, delete)
}

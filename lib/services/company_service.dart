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

  Future<Company> getCompany(String accessToken, String companyId) async {
    try {
      final response = await _client.get(
        url: '$remoteBaseUrl/rest/v1/companies?id=eq.$companyId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      return Company.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error getting company',
          level: 'error',
          extra: {'context': 'CompanyService.getCompany', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<Company> createCompany(String accessToken, Company company) async {
    try {
      final response = await _client.post(
        url: '$remoteBaseUrl/rest/v1/companies',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: company.toJson(),
      );
      return Company.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error creating company',
          level: 'error',
          extra: {'context': 'CompanyService.createCompany', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<Company> updateCompany(
      String accessToken, String companyId, Map<String, dynamic> data) async {
    try {
      final response = await _client.patch(
        url: '$remoteBaseUrl/rest/v1/companies?id=eq.$companyId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Prefer': 'return=representation',
        },
        data: data,
      );
      return Company.fromJson(response.data[0]);
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error updating company',
          level: 'error',
          extra: {'context': 'CompanyService.updateCompany', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteCompany(String accessToken, String companyId) async {
    try {
      final response = await _client.delete(
        url: '$remoteBaseUrl/rest/v1/companies?id=eq.$companyId',
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode != 204) {
        throw Exception('Failed to delete company');
      }
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error deleting company',
          level: 'error',
          extra: {'context': 'CompanyService.deleteCompany', 'error': e},
        ),
      );
      rethrow;
    }
  }
}

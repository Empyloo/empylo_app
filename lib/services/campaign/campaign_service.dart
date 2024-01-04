// Path: lib/services/campaign_service.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http/http_client.dart';
import 'package:empylo_app/services/sentry/sentry_service.dart';
import 'package:empylo_app/models/campaign.dart';
import 'dart:convert';

import 'package:empylo_app/utils/role_based_url.dart';

class CampaignsService {
  final HttpClient _httpClient;
  final SentryService _sentry;

  CampaignsService({
    required HttpClient httpClient,
    required SentryService sentry,
  })  : _httpClient = httpClient,
        _sentry = sentry;

  Future<Response> createCampaign({
    required Campaign campaign,
    String? accessToken,
  }) async {
    try {
      Map<String, dynamic> data = {
        "queue_name": "campaigns",
        "action_type": "create_campaign",
        "payload": campaign.toJson(),
      };
      String jsonString = jsonEncode(data);
      return await _httpClient.post(
          url: 'https://app.empylo.com/api/v1/campaigns',
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          data: jsonString);
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'createCampaign'},
      ));
      return Response(
          requestOptions: RequestOptions(path: '/campaigns'),
          statusCode: 500,
          statusMessage: 'Error: Could not connect to server.');
    }
  }

  Future<Response> updateCampaign({
    required Campaign campaign,
    String? accessToken,
    required String userRole,
    required String companyId,
  }) async {
    final data = campaign.toJsonForUpdate();
    // Use getRoleBasedUrl for URL generation
    final url = getRoleBasedUrl(
      userRole,
      companyId,
      'rest/v1/campaigns?id=eq.${campaign.id}',
    );
    try {
      return await _httpClient.patch(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        data: data,
      );
    } catch (e) {
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'updateCampaign'},
      ));
      return Response(
          requestOptions: RequestOptions(path: '/campaigns'),
          statusCode: 500,
          statusMessage: 'Error: Could not connect to server.');
    }
  }

  Future<List<Campaign>> getCampaigns(
      String companyId, String accessToken, String userRole,
      {String? campaignId}) async {
    try {
      final filter = getRoleBasedFilter(userRole, companyId);
      final url = getRoleBasedUrl(
        userRole,
        companyId,
        'rest/v1/campaign_with_links',
        queryParams: {
          if (campaignId != null) 'id': 'eq.$campaignId',
        },
      );

      final response = await _httpClient.get(
        url: url + filter,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response.data
          .map<Campaign>((campaign) => Campaign.fromJson(campaign))
          .toList();
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error fetching campaigns',
          level: 'error',
          extra: {
            'context': 'CampaignService.getCampaigns',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteCampaign(String accessToken, String companyId,
      String userRole, String campaignId) async {
    try {
      final url = getRoleBasedUrl(
        userRole,
        companyId,
        'rest/v1/campaigns?id=eq.$campaignId',
        queryParams: {
          'id': 'eq.$campaignId',
        },
      );

      await _httpClient.delete(
        url: url,
        headers: {
          'apikey': remoteAnonKey,
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error deleting campaign',
          level: 'error',
          extra: {
            'context': 'CampaignService.deleteCampaign',
            'error': e,
          },
        ),
      );
      rethrow;
    }
  }
}

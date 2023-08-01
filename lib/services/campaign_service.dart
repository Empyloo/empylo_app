// Path: lib/services/campaign_service.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/models/campaign.dart';

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
      return await _httpClient.post(
        url: 'https://app.empylo.com/api/v1/campaigns',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        data: {
          "queue_name": "campaigns",
          "action_type": "create_campaign",
          "payload": campaign.toJson()
        },
      );
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
    required String campaignId,
    required Campaign campaign,
    String? accessToken,
  }) async {
    final data = campaign.toJson();
    data['id'] = campaignId;
    try {
      return await _httpClient.put(
        url: 'https://app.empylo.com/api/v1/campaigns',
        headers: {
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

  Future<Campaign> getCampaign(String accessToken, String campaignId) async {
    try {
      final response = await _httpClient.get(
        url: 'https://app.empylo.com/api/v1/campaigns?id=eq.$campaignId',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      return Campaign.fromJson(response
          .data[0]); // assuming that Campaign class has a fromJson method
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error getting campaign',
          level: 'error',
          extra: {'context': 'CampaignsService.getCampaign', 'error': e},
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteCampaign(String accessToken, String campaignId) async {
    try {
      await _httpClient.delete(
        url: 'https://app.empylo.com/api/v1/campaigns?id=eq.$campaignId',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
    } catch (e) {
      await _sentry.sendErrorEvent(
        ErrorEvent(
          message: 'Error deleting campaign',
          level: 'error',
          extra: {'context': 'CampaignsService.deleteCampaign', 'error': e},
        ),
      );
      rethrow;
    }
  }
}

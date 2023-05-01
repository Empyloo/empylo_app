// Path: lib/state_management/auth_state_notifier.dart
import 'package:dio/dio.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/sentry_service.dart';

class UserInviteService {
  final HttpClient _httpClient;
  final SentryService _sentry;

  UserInviteService({
    httpClient,
    sentry,
  })  : _httpClient = httpClient,
        _sentry = sentry;

  /// For inviting user/s to the organization, an admin user
  /// will add an email, emails or upload a csv file with
  /// the email addresses of the invitees.
  /// If only one email is provided, it will be put in a list
  /// of one email.
  /// The `invites` service method should expect a list of
  ///  `Invite` strings (emails).
  /// The acceess token of the user sending invites is added
  /// headers. organizationId and organizationName are optional.
  Future<Response> invites({
    required List<String> emails,
    String? organizationId,
    String? organizationName,
    String? accessToken,
    String? role,
  }) async {
    try {
      return await _httpClient.post(
        url: 'https://app.empylo.com/api/v1/user-invites',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        data: {
          'emails': emails,
          'company_id': organizationId,
          'company_name': organizationName,
          'queue_name': 'invite-user-task-queue',
          // add role to the invite if it is provided
          if (role != null) 'role': role,
        },
      );
    } catch (e) {
      print('Error: $e');
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'invites'},
      ));
      return Response(
          requestOptions: RequestOptions(path: '/invites'),
          statusCode: 500,
          statusMessage: 'Error: Could not connect to server.');
    }
  }

  /// For deleting user invites, an admin user will provide
  /// the email of the invitee to be deleted.
  /// The `delete` service method should expect a list of `Email`
  /// strings.
  /// The acceess token of the user sending invites is added
  /// headers and the organizationId is added as a query parameter.
  /// organizationId is optional.
  Future<Response> deletes({
    required List<String> emails,
    String? organizationId,
    String? accessToken,
  }) async {
    try {
      return await _httpClient.post(
        url: 'https://app.empylo.com/api/v1/user-invites',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        data: {
          'emails': emails,
          'company_id': organizationId,
          'queue_name': 'delete-user-task-queue',
        },
      );
    } catch (e) {
      print('Error deleting user: $e');
      await _sentry.sendErrorEvent(ErrorEvent(
        message: e.toString(),
        level: 'error',
        extra: {'context': 'deletes'},
      ));
      return Response(
          requestOptions: RequestOptions(path: '/deletes'),
          statusCode: 500,
          statusMessage: 'Error: Could not connect to server.');
    }
  }
}

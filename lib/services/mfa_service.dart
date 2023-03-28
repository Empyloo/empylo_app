// Path: lib/services/sentry_service.dart
import 'dart:convert';

import 'package:empylo_app/constants/api_constants.dart';
import 'package:empylo_app/models/sentry.dart';
import 'package:empylo_app/services/http_client.dart';
import 'package:empylo_app/services/sentry_service.dart';
import 'package:empylo_app/state_management/qr_code_provider.dart';
import 'package:empylo_app/ui/molecules/dialogues/mfa_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decode/jwt_decode.dart';

class MFAService {
  final String baseUrl;
  final HttpClient httpClient;
  final SentryService sentry;

  MFAService(
      {required this.baseUrl, required this.httpClient, required this.sentry});

  Future<Map<String, dynamic>> enroll({
    required String accessToken,
    String factorType = 'totp',
    String? issuer,
    String? friendlyName,
  }) async {
    try {
      print('Enrolling user...');
      final response = await httpClient.post(
        url: '$baseUrl/auth/v1/factors',
        headers: {
          'apikey': remoteAnonKey,
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        data: jsonEncode({
          'friendly_name': friendlyName,
          'factor_type': factorType,
          'issuer': issuer,
        }),
      );
      // print('Enrolled user: ${response.data}');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error enrolling user: ${response.data}'
            'url: $baseUrl/auth/v1/factors');
        await sentry.sendErrorEvent(
          ErrorEvent(
            message: "Error enrolling user.",
            level: "error",
            extra: {
              'context': response.data,
              'url': '$baseUrl/auth/v1/factors'
            },
          ),
        );
        throw Exception('Enroll failed');
      }
    } catch (e) {
      print('Error enrolling user: $baseUrl/auth/v1/factors');
      print('Error enrolling user: ${e.toString()}');
      print('Error enrolling user: $e');
      await sentry.sendErrorEvent(
        ErrorEvent(
          message: "Error enrolling user.",
          level: "error",
          extra: {'context': e.toString(), 'url': '$baseUrl/auth/v1/factors'},
        ),
      );
      throw Exception('Enroll failed');
    }
  }

  Future<Map<String, dynamic>> verify({
    required String accessToken,
    required String factorId,
    required String challengeId,
    required String code,
  }) async {
    print('Verifying user...');
    final response = await httpClient.post(
      url: '$baseUrl/auth/v1/factors/$factorId/verify',
      headers: {
        'apikey': remoteAnonKey,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      data: jsonEncode({
        'code': code,
        'challenge_id': challengeId,
      }),
    );
    print('Verified user: ${response.statusCode}');
    print('Verified user: ${response.toString()}');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      await sentry.sendErrorEvent(
        ErrorEvent(
          message: "Error verifying user.",
          level: "error",
          extra: {
            'context': response.data,
            'url': '$baseUrl/auth/v1/factors/$factorId/verify',
          },
        ),
      );
      throw Exception('Verify failed');
    }
  }

  Future<Map<String, dynamic>> challenge({
    required String accessToken,
    required String factorId,
  }) async {
    final response = await httpClient.post(
      url: '$baseUrl/auth/v1/factors/$factorId/challenge',
      headers: {
        'apikey': remoteAnonKey,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      await sentry.sendErrorEvent(
        ErrorEvent(
          message: "Error challenging user.",
          level: "error",
          extra: {
            'context': response.data,
            'url': '$baseUrl/auth/v1/factors/$factorId/challenge',
          },
        ),
      );
      throw Exception('Challenge failed');
    }
  }

  Future<Map<String, dynamic>> challengeAndVerify({
    required String accessToken,
    required String factorId,
    required String code,
  }) async {
    final challengeRes =
        await challenge(accessToken: accessToken, factorId: factorId);
    final challengeId = challengeRes['id'];
    return verify(
      accessToken: accessToken,
      factorId: factorId,
      challengeId: challengeId,
      code: code,
    );
  }

  Future<Map<String, dynamic>> unenroll({
    required String accessToken,
    required String factorId,
  }) async {
    final response = await httpClient
        .delete(url: '$baseUrl/auth/v1/factors/$factorId', headers: {
      'apikey': remoteAnonKey,
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      await sentry.sendErrorEvent(
        ErrorEvent(
          message: "Error unenrolling user.",
          level: "error",
          extra: {
            'context': response.data,
            'url': '$baseUrl/auth/v1/factors/$factorId',
          },
        ),
      );
      throw Exception('Unenroll failed');
    }
  }

  Map<String, dynamic> getAuthenticatorAssuranceLevel(
      String accessToken, Map<String, dynamic> user) {
    final payload = Jwt.parseJwt(accessToken);

    var currentLevel = payload['aal'];
    var nextLevel = currentLevel;

    if (user['factors'].any((factor) => factor['status'] == 'verified')) {
      nextLevel = 'aal2';
    }

    final amr = [
      for (final e in payload['amr'])
        {
          'method': e['method'],
          'timestamp':
              DateTime.fromMillisecondsSinceEpoch(e['timestamp'] * 1000)
        }
    ];

    return {
      'currentLevel': currentLevel,
      'nextLevel': nextLevel,
      'currentAuthenticationMethods': amr
    };
  }

  Map<String, dynamic> getVerifiedFactor(Map<String, dynamic> user) {
    final factors = user['factors'] ?? [];
    // get the verified factor that was enrolled last
    final factor = factors
        .where((factor) => factor['status'] == 'verified')
        .reduce((value, element) =>
            value['created'] > element['created'] ? value : element);

    return factor;
  }

  bool isEnrolled(Map<String, dynamic> data) {
    return data['factors'] != null && data['factors'].length > 0;
  }

  Future<String?> showMFADialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return const MFADialog();
      },
    );
  }

  Future<Map<String, dynamic>?> enrollAndVerifyMFA({
    required WidgetRef ref,
    required String accessToken,
    required Future<String?> Function() showDialogFn,
  }) async {
    String? factorId;
    try {
      print('Enrolling MFA');
      // Enroll the user
      final enrollmentResponse = await enroll(accessToken: accessToken);
      factorId = enrollmentResponse['id'];
      // Set the QR code data URL in the provider
      ref.read(qrCodeProvider.notifier).state =
          'data:image/svg+xml;utf-8,${enrollmentResponse['totp']['qr_code']}';
      // Set the secret code in the provider
      ref.read(secretCodeProvider.notifier).state =
          enrollmentResponse['totp']['secret'];
      // Show the MFA dialog
      final String? mfaCode = await showDialogFn();
      print('mfaCode: $mfaCode');
      if (mfaCode != null && mfaCode.isNotEmpty && factorId != null) {
        final verificationResponse = await challengeAndVerify(
          accessToken: accessToken,
          factorId: factorId,
          code: mfaCode,
        );
        // Check if the MFA verification was successful
        if (verificationResponse['user'] != null) {
          return verificationResponse;
        } else {
          throw Exception('MFA verification failed');
        }
      } else {
        throw Exception('MFA code not provided');
      }
    } catch (e) {
      if (factorId != null) {
        await unenroll(accessToken: accessToken, factorId: factorId);
      }
      await sentry.sendErrorEvent(
        ErrorEvent(
          message: "Error enrolling and verifying MFA.",
          level: "error",
          extra: {'context': e.toString()},
        ),
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> verifiedChallengeFlow({
    required WidgetRef ref,
    required String accessToken,
    required Map<String, dynamic> user,
    required Future<String?> Function() showDialogFn,
  }) async {
    try {
      final factorId = getVerifiedFactor(user)['id'];
      if (factorId != null) {
        final String? mfaCode = await showDialogFn();
        if (mfaCode != null && mfaCode.isNotEmpty) {
          final verificationResponse = await challengeAndVerify(
            accessToken: accessToken,
            factorId: factorId,
            code: mfaCode,
          );
          // Check if the MFA verification was successful
          if (verificationResponse['user'] != null) {
            return verificationResponse;
          } else {
            throw Exception('MFA verification failed');
          }
        } else {
          throw Exception('MFA code not provided');
        }
      } else {
        return await enrollAndVerifyMFA(
          ref: ref,
          accessToken: accessToken,
          showDialogFn: showDialogFn,
        );
      }
    } catch (e) {
      await sentry.sendErrorEvent(
        ErrorEvent(
          message: "Error verifying challenge flow.",
          level: "error",
          extra: {'context': e.toString()},
        ),
      );
      rethrow;
    }
  }
}

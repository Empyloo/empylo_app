import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MFAService {
  final String accessToken;
  final String baseUrl;

  const MFAService({
    required this.accessToken,
    required this.baseUrl,
  });

  Future<Map<String, dynamic>> enroll() async {
    final url = Uri.parse('$baseUrl/rest/v1/auth/factors');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final body = json.encode({'factor_type': 'totp'});
    final response = await http.post(url, headers: headers, body: body);
    final jsonBody = json.decode(response.body);
    return jsonBody;
  }

  Future<Map<String, dynamic>> challenge(String factorId) async {
    final url = Uri.parse('$baseUrl/rest/v1/auth/factors/$factorId/challenge');
    final headers = {'Authorization': 'Bearer $accessToken'};
    final response = await http.post(url, headers: headers);
    final jsonBody = json.decode(response.body);
    return jsonBody;
  }

  Future<Map<String, dynamic>> verify(
      String factorId, String challengeId, String code) async {
    final url = Uri.parse('$baseUrl/rest/v1/auth/factors/$factorId/verify');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final body = json.encode({'challenge_id': challengeId, 'code': code});
    final response = await http.post(url, headers: headers, body: body);
    final jsonBody = json.decode(response.body);
    return jsonBody;
  }

  Future<void> unenroll(String factorId) async {
    final url = Uri.parse('$baseUrl/rest/v1/auth/factors/$factorId');
    final headers = {'Authorization': 'Bearer $accessToken'};
    await http.delete(url, headers: headers);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = StateProvider<TokenData?>((ref) => null);

class TokenData {
  final String accessToken;
  final String refreshToken;

  TokenData({required this.accessToken, required this.refreshToken});
}

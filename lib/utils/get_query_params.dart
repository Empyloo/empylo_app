// Path: lib/utils/get_query_params.dart
import 'package:empylo_app/models/redirect_params.dart';

RedirectParams? getQueryParams(Uri uri) {
  final decodedFragment = Uri.decodeFull(uri.fragment).replaceAll('#', '?');
  final uriObject = Uri.parse(decodedFragment);
  if (uriObject.queryParameters['access_token'] == null) {
    return null;
  }
  return RedirectParams.fromJson(uriObject.queryParameters);
}

Map<String, String> parseSurveyFragment(String fragment) {
  final result = <String, String>{};
  final parts = fragment.split('&');

  for (var part in parts) {
    final keyValue = part.split('=');

    if (keyValue.length != 2) {
      throw FormatException('Invalid query parameter: $part');
    }

    final key = keyValue[0];
    final value = keyValue[1];
    result[key] = Uri.decodeFull(value);
  }

  return result;
}
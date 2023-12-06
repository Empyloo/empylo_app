// Path: lib/utils/get_query_params.dart
import 'package:empylo_app/models/redirect_params.dart';
import 'package:empylo_app/models/url/url_parameters.dart';

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

UrlParameters? parseUrl(String url) {
  Uri uri = Uri.parse(url);
  final decodedFragment = Uri.decodeFull(uri.fragment).replaceAll('#', '?');
  final parameters = Uri.parse(decodedFragment).queryParameters;
  if (parameters['access_token'] == null) {
    return null;
  }
  return UrlParameters.fromMap(parameters);
}

void main() {
  String urlNoFragment = "https://app.empylo.com/";
  String url =
      "https://app.empylo.com/#/#access_token=eyJhbGciJ0eXifQ.eyJhcCI6MTcwMDU1dLCJaW9uX2lkIjoiMDA0Nzgw.1nUx5otb9-UW_T5XsD5WSOq0&expires_at=1700552791&expires_in=3600&refresh_token=OpCld-NKdwHAjQ8Ow68jAQ&token_type=bearer&type=recovery";
  UrlParameters? urlParameters = parseUrl(url);
  print(urlParameters!.type);
}

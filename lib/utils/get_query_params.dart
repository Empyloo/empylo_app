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

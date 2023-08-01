import 'package:empylo_app/constants/api_constants.dart';

String getRoleBasedUrl(String userRole, String companyId, String path,
    {Map<String, String>? queryParams}) {
  var url = '$remoteBaseUrl/$path';
  if (userRole == 'superAdmin') {
    // No additional filters for superAdmin
  } else if (userRole == 'admin') {
    queryParams ??= {};
    queryParams['company_id'] = 'eq.$companyId';
  } else {
    throw Exception('Unauthorized');
  }
  if (queryParams != null && userRole != 'superAdmin') {
    final queryString = queryParams.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    url += '?$queryString';
  }
  return url;
}

String getRoleBasedFilter(String userRole, String companyId) {
  if (userRole == 'superAdmin') {
    // No additional filters for superAdmin
    return '';
  } else if (userRole == 'admin') {
    return '?company_id=eq.$companyId';
  } else {
    throw Exception('Unauthorized');
  }
}
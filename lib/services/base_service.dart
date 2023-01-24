/*
A service is a class that provides a set of methods to perform a specific task.
In this case, the base service class is used to provide the basic functionality
for all services in the app. This includes the ability to make HTTP requests
to the backend retry, log and to handle errors. The base service class is
abstract and should be extended by all services in the app.

Instantiated with headers, baseUrl is optional.
The headers should include the authorization token, anonymous token will be
used if no token is provided.

Methods need at least a string path and a body, the body is optional for GET.
The body should be a map of strings and dynamic.

An example of an endpoint is:
```

curl 'https://banckend.com/rest/v1/users?select=id' \
-H "apikey: KEY" \
-H "Authorization: Bearer KEY"
```

*/

// Path: lib/services/base_service.dart

abstract class BaseService {
  final String baseUrl;
  final Map<String, String> headers;

  BaseService({
    required this.headers,
    this.baseUrl = '',
  });

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? body,
  });

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  });

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  });

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
  });
}

/*
This file defines the DB service class that extends the base service class and
is used to make requests to the database. It uses the dio package to make the
requests, flutter_riverpod 2.0 to manage state.
  
  */
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

// Path: lib/services/bases.dart

abstract class BaseClient {
  Future<dynamic> get(String path, {int? retry, String? apiKey});
  Future<dynamic> post(String path, dynamic data, {int? retry, String? apiKey});
  Future<dynamic> put(String path, dynamic data, {int? retry, String? apiKey});
  Future<dynamic> delete(String path, {int? retry, String? apiKey});
}


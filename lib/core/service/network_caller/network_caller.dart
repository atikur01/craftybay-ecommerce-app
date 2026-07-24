import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

part 'network_response.dart';

class NetworkCaller {
  final Logger _logger = Logger();

  final Map<String, String> Function() headers;
  final VoidCallback onUnauthorized;

  NetworkCaller({required this.headers, required this.onUnauthorized});

  // Get
  Future<NetworkResponse> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, headers: headers());
      final Response response = await get(uri, headers: headers());
      _logResponse(response);

      if (response.statusCode == 200) {
        // Success
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        // Unauthorized
        onUnauthorized();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Unauthorized',
        );
      } else {
        // Failed
        // {
        //   'message' : 'something went wrong'
        // }
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['msg'] ?? 'Something went wrong!',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  // Post
  Future<NetworkResponse> postRequest(
    String url, {
    Map<String, dynamic>? body,
    bool isFromLogin = false
  }) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, requestBody: body, headers: headers());
      final Response response = await post(
        uri,
        headers: headers(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else if (response.statusCode == 401 && isFromLogin == false) {
        // Unauthorized
        onUnauthorized();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Unauthorized',
        );
      } else {
        // Failed
        // {
        //   'message' : 'something went wrong'
        // }
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['msg'] ?? 'Something went wrong!',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> deleteRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, headers: headers());
      final Response response = await delete(uri, headers: headers());
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 204) {
        final decodedJson = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        onUnauthorized();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Unauthorized',
        );
      } else {
        final decodedJson = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['msg'] ?? 'Something went wrong!',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> putRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, requestBody: body, headers: headers());
      final Response response = await put(
        uri,
        headers: headers(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedJson = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        onUnauthorized();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Unauthorized',
        );
      } else {
        final decodedJson = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['msg'] ?? 'Something went wrong!',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> patchRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, requestBody: body, headers: headers());
      final Response response = await patch(
        uri,
        headers: headers(),
        body: jsonEncode(body),
      );
      _logResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedJson = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        onUnauthorized();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Unauthorized',
        );
      } else {
        final decodedJson = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['msg'] ?? 'Something went wrong!',
        );
      }
    } on Exception catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  void _logRequest(
    String url, {
    Map<String, dynamic>? requestBody,
    Map<String, String>? headers,
  }) {
    _logger.d('''URL => $url
    Headers => $headers
    RequestBody => $requestBody
    ''');
  }

  void _logResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      _logger.i('''URL => ${response.request?.url}
    Status Code => ${response.statusCode}
    RequestBody => ${response.body}
    ''');
    } else {
      _logger.e('''URL => ${response.request?.url}
    Status Code => ${response.statusCode}
    RequestBody => ${response.body}
    ''');
    }
  }
}


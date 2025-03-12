import 'dart:convert';
import 'package:financeapp_app/config.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {

  Future<Map<String, String>> _getRequestHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, String>> _addHeaders(Map<String, String> headers) async {
    final defaultHeaders = await _getRequestHeaders();
    headers.addAll(defaultHeaders);
    return headers;
  }
 
  Future<Response> _performRequest(String method, String path, {Object? body, Map<String, String>? headers}) async {
    final Uri uri = Uri.parse('$baseUrl/$path');
    final requestHeaders = await _addHeaders(headers ?? <String, String>{});

    // Converteer de body naar een JSON-string als deze niet null is.
    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      switch (method) {
        case 'POST':
          return post(uri, headers: requestHeaders, body: encodedBody);
        case 'GET':
          return get(uri, headers: requestHeaders);
        case 'PUT':
          return put(uri, headers: requestHeaders, body: encodedBody);
        case 'DELETE':
          return delete(uri, headers: requestHeaders);
        default:
          throw Exception('Invalid method: $method');
      }
    } catch (e) {
      print('Error during $method request to $uri: $e'); 
      rethrow;   
    }
  }

  Future<Response> postAsync(String path, {Object? body, Map<String, String>? headers}) async {
    return _performRequest('POST', path, body: body, headers: headers);
  }

  Future<Response> getAsync(String path, {Object? body, Map<String, String>? headers}) async {
    return _performRequest('GET', path, body: body, headers: headers);
  }

  Future<Response> putAsync(String path, {Object? body, Map<String, String>? headers}) async {
    return _performRequest('PUT', path, body: body, headers: headers);
  }

  Future<Response> deleteAsync(String path, {Object? body, Map<String, String>? headers}) async {
    return _performRequest('DELETE', path, body: body, headers: headers);
  }
}

import 'dart:convert';
import 'package:financeapp_app/config.dart';
import 'package:financeapp_app/dtos/authentication_dto.dart';
import 'package:financeapp_app/dtos/response_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  String? _token;

  bool get isAuthenticated => _token != null;
  String? get token => _token;

  /// Private helper method to perform an authentication POST request.
  Future<Response> _authRequest(String endpoint, AuthenticationDTO dto) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        _token = response.body;
        notifyListeners();
        return Response(message: 'Successfully logged in.', success: true);
      } 
    
      final errorMessage = 'Failed to $endpoint: ${response.body}';
      return Response(message: errorMessage, success: false);
    } 
    
    catch (e) {
      final errorMessage = 'An error occurred while trying to $endpoint: $e';
      return Response(message: errorMessage, success: false);
    }
  }

  Future<Response> login(AuthenticationDTO dto) async {
    return await _authRequest('login', dto);
  }

  Future<Response> register(AuthenticationDTO dto) async {
    return await _authRequest('register', dto);
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}

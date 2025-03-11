import 'dart:convert';
import 'package:financeapp_app/config.dart';
import 'package:financeapp_app/dtos/authentication_dto.dart';
import 'package:financeapp_app/dtos/response_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  String? _token;

  bool get isAuthenticated => _token != null;
  String? get token => _token;

  AuthService() {
    _loadTokenFromStorage();
  }

  /// Loads the token from local storage when the service is initialized.
  Future<void> _loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
    notifyListeners();
  }

  /// Saves the token to local storage.
  Future<void> _saveTokenToStorage(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  /// Removes the token from local storage.
  Future<void> _removeTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

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
        await _saveTokenToStorage(_token!);
        notifyListeners();
        return Response(message: '', success: true);
      } 
    
      final errorMessage = 'Failed to $endpoint: ${response.body}';
      return Response(message: errorMessage, success: false);
    } 
    
    catch (e) {
      final errorMessage = 'An error occurred while trying to $endpoint: $e';
      print(errorMessage);
      return Response(message: errorMessage, success: false);
    }
  }

  Future<Response> login(AuthenticationDTO dto) async {
    return await _authRequest('login', dto);
  }

  Future<Response> register(AuthenticationDTO dto) async {
    return await _authRequest('register', dto);
  }

  Future<void> logout() async {
    _token = null;
    await _removeTokenFromStorage();
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:financeapp_app/config.dart';
import 'package:financeapp_app/dtos/auth_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:financeapp_app/services/http_service.dart';

class AuthService extends ChangeNotifier {
  String? _token;
  bool get isAuthenticated => _token != null;

  final HttpService _httpService = HttpService();

  AuthService() {
    _getTokenFromStorage();
  }

  Future<void> _getTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final expiryString = prefs.getString('jwt_expiry');

    if (_isTokenValid(token, expiryString)) {
      _token = token;
      notifyListeners();
    } else {
      await _removeTokenFromStorageAsync();
    }
  }

  bool _isTokenValid(String? token, String? expiryString) {
    if (token == null || expiryString == null) {
      return false;
    }

    final expiryTime = DateTime.tryParse(expiryString);
    if (expiryTime != null && DateTime.now().isBefore(expiryTime)) {
      return true;
    }

    return false;
  }

  /// Saves the token and its expiry time to local storage.
  Future<void> _saveTokenToStorageAsync(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now().add(const Duration(minutes: tokenExpiryMinutes));
    await prefs.setString('jwt_token', token);
    await prefs.setString('jwt_expiry', expiryTime.toIso8601String());
  }

  /// Removes the token and expiry time from local storage.
  Future<void> _removeTokenFromStorageAsync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('jwt_expiry');
  }

  Future<void> _handleAuthenticationAsync (String responseBody) async {
    // Parse the token from the response body
    final tokenObject = jsonDecode(responseBody) as Map<String, dynamic>;
    final token = tokenObject['token'] as String;

    // Save the token...    
    _token = token;
    await _saveTokenToStorageAsync(token);
    notifyListeners();
  }

  Future<Response> loginAsync(AuthRequest dto) async {
    var response = await _httpService.postAsync('auth/login', body: dto);
    if (response.statusCode != 200) {
      return response;
    }

    await _handleAuthenticationAsync(response.body);
    return response;
  }

  Future<Response> registerAsync(AuthRequest dto) async {
    var response = await _httpService.postAsync('auth/register', body: dto);
    if (response.statusCode != 200) {
      return response;
    }
    
    await _handleAuthenticationAsync(response.body);
    return response;
  }

  Future<void> logoutAsync() async {
    _token = null;
    await _removeTokenFromStorageAsync();
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  String? _token;

  bool get isAuthenticated => _token != null;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      final url = Uri.parse('http://10.0.2.2:5164/api/v1/auth/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Specify JSON format
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        _token = response.body;
        notifyListeners();
      } else {
        print('Failed to log in: ${response.body}');
      }
    } catch (e) {
      print('An error occurred while trying to log in: $e');
    }
  }

  Future<void> register(String email, String password) async {
    try {
      final url = Uri.parse('http://10.0.2.2:5164/api/v1/auth/register');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Specify JSON format
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        _token = response.body;
        notifyListeners();
      } else {
        print('Failed to register: ${response.body}');
      }
    } catch (e) {
      print('An error occurred while trying to register: $e');
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}

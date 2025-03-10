import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  String? _token;

  bool get isAuthenticated => _token != null;
  String? get token => _token;

  // Temporary fake login method.
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _token = "fake_jwt_token_for_$email";
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}

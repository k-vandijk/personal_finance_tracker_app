import 'package:financeapp_app/dtos/auth_request.dart';
import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/widgets/auth_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final AuthService authService = AuthService();

    void login(String email, String password) async {
      await authService.loginAsync(AuthRequest(email: email, password: password));
      // if (response.statusCode != 200) {
      //   ScaffoldMessenger.of(context).clearSnackBars();
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
      // }
    }

    void register(String email, String password) async {
      await authService.registerAsync(AuthRequest(email: email, password: password));
      // if (response.statusCode != 200) {
      //   ScaffoldMessenger.of(context).clearSnackBars();
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.body)));
      // }
    }

    return Scaffold(
      body: Center(
        child: AuthForm(
          onLogin: login,
          onRegister: register,
        ),
      ),
    );
  }
}

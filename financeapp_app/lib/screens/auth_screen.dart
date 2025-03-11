import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    void login(String email, String password) async {
      await authService.login(email, password);
    }

    void register(String email, String password) async {
      await authService.register(email, password);
    }

    return Scaffold(
      body: Center(child: AuthForm(onLogin: login, onRegister: register)),
    );
  }
}

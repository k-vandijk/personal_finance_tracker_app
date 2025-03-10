import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onSubmit(String email, String password) async {
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.login(email, password);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
      }
    }

    return Scaffold(
      body: Center(child: AuthForm(onSubmit: onSubmit)),
    );
  }
}

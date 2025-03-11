import 'package:financeapp_app/dtos/authentication_dto.dart';
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
      var response = await authService.login(AuthenticationDTO(email: email, password: password));
    
      if (!response.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
      }
    }

    void register(String email, String password) async {
      var response = await authService.register(AuthenticationDTO(email: email, password: password));
    
      if (!response.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
      }
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

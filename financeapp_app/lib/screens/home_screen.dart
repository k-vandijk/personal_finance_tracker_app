import 'package:financeapp_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await authService.logoutAsync();
        },
        child: const Text('Logout'),
      ),
    );
  }
}

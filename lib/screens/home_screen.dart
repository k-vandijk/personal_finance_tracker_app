import 'package:kubera/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final AuthService authService = AuthService();

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

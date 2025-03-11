import 'package:financeapp_app/screens/assets_screen.dart';
import 'package:financeapp_app/screens/auth_screen.dart';
import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/widgets/circle_nav_button.dart';
import 'package:financeapp_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ActiveScreen { home, assets }

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  ActiveScreen _activeScreen = ActiveScreen.home;

  void _changeScreen(ActiveScreen screen) {
    setState(() {
      _activeScreen = screen;
    });
  }

  Widget _buildScreen() {
    switch (_activeScreen) {
      case ActiveScreen.assets:
        return const AssetsScreen();
      default:
        return const HomeScreen();
    }
  }

  Widget _buildBottomNavigation() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleNavButton(
            inactiveSize: 50,
            icon: Icons.inventory,
            active: _activeScreen == ActiveScreen.assets,
            onPressed: () => _changeScreen(ActiveScreen.assets),
          ),
          const SizedBox(width: 12),
          CircleNavButton(
            inactiveSize: 50,
            icon: Icons.home,
            active: _activeScreen == ActiveScreen.home,
            onPressed: () => _changeScreen(ActiveScreen.home),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    if (!authService.isAuthenticated) return const AuthScreen();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              child: _buildScreen(),
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }
}

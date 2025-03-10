import 'package:financeapp_app/screens/assets_screen.dart';
import 'package:financeapp_app/screens/profile_screen.dart';
import 'package:financeapp_app/widgets/circle_nav_button.dart';
import 'package:flutter/material.dart';
import 'package:financeapp_app/screens/home_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  String activeScreen = 'home-screen';

  void changeScreen(String screen) {
    setState(() {
      activeScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget;

    switch (activeScreen) {
      case 'assets-screen':
        screenWidget = const AssetsScreen();
        break;
      case 'profile-screen':
        screenWidget = const ProfileScreen();
        break;
      default:
        screenWidget = const HomeScreen();
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              child: screenWidget,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleNavButton(
                  inactiveSize: 50,
                  icon: Icons.inventory,
                  active: activeScreen == 'assets-screen',
                  onPressed: () => changeScreen('assets-screen'),
                ),
                CircleNavButton(
                  inactiveSize: 50,
                  icon: Icons.home,
                  active: activeScreen == 'home-screen',
                  onPressed: () => changeScreen('home-screen'),
                ),
                CircleNavButton(
                  inactiveSize: 50,
                  icon: Icons.person,
                  active: activeScreen == 'profile-screen',
                  onPressed: () => changeScreen('profile-screen'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

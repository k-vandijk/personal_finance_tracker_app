import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:financeapp_app/screens/assets_screen.dart';
import 'package:financeapp_app/screens/home_screen.dart';
import 'package:financeapp_app/screens/investments_screen.dart';
import 'package:financeapp_app/screens/savings_screen.dart';
import 'package:financeapp_app/screens/auth_parent_screen.dart';
import 'package:financeapp_app/screens/auth_child_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _childSessionActive = false;

  // Called after successful parent (email/password) authentication.
  void _activateChildSession() {
    setState(() {
      _childSessionActive = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for auth state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If no Firebase user, show the parent auth screen.
        if (!snapshot.hasData) {
          return AuthParentScreen(onAuthenticated: _activateChildSession);
        }

        // If user exists but child session is not active, show child auth.
        if (!_childSessionActive) {
          return AuthChildScreen(onAuthenticated: _activateChildSession);
        }

        // Otherwise, show the main app shell.
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Row(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).colorScheme.tertiary,
                  labelColor: Theme.of(context).colorScheme.tertiary,
                  unselectedLabelColor: Theme.of(context).colorScheme.tertiary.withAlpha(200),
                  dividerColor: Theme.of(context).colorScheme.surface,
                  overlayColor: WidgetStateColor.transparent,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  labelStyle: const TextStyle(fontSize: 14),
                  tabs: const [
                    Tab(text: 'Home'),
                    Tab(text: 'Collect'),
                    Tab(text: 'Save'),
                    Tab(text: 'Invest'),
                  ],
                ),
                const Spacer(),
                IconButton(
                  iconSize: 35,
                  icon: const Icon(Icons.account_circle),
                  color: Theme.of(context).colorScheme.onSurface,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              HomeScreen(),
              AssetsScreen(),
              SavingsScreen(),
              InvestmentsScreen(),
            ],
          ),
        );
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:financeapp_app/screens/assets_screen.dart';
import 'package:financeapp_app/screens/home_screen.dart';
import 'package:financeapp_app/screens/investments_screen.dart';
import 'package:financeapp_app/screens/savings_screen.dart';
import 'package:financeapp_app/screens/auth_parent_screen.dart';
import 'package:financeapp_app/screens/auth_child_screen.dart';
import 'package:financeapp_app/screens/profile_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _childSessionActive = false;

  // Called after successful authentication.
  void _activateChildSession() {
    setState(() {
      _childSessionActive = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final double paddingSize = MediaQuery.of(context).size.width * 0.12;
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for auth state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // If there's no Firebase user, show the parent authentication screen.
        if (!snapshot.hasData) {
          return AuthParentScreen(onAuthenticated: _activateChildSession);
        }
        // If user exists but child session is not active, show child auth.
        if (!_childSessionActive) {
          return AuthChildScreen(onAuthenticated: _activateChildSession);
        }
        
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.tertiary,
              unselectedLabelColor: Theme.of(context).colorScheme.tertiary.withAlpha(120),
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              overlayColor: WidgetStateColor.transparent,
              dividerHeight: -1,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicator: BoxDecoration(),
              tabs: [
                const Tab(text: 'Home'),
                const Tab(text: 'Collect'),
                const Tab(text: 'Save'),
                const Tab(text: 'Invest'),
                Padding(
                  padding: EdgeInsets.only(left: paddingSize),
                  child: const Tab(icon: Icon(Icons.account_circle, size: 28)),
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
              ProfileScreen(),
            ],
          ),
        );
      },
    );
  }
}

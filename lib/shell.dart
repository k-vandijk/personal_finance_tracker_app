import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kubera/screens/assets_screen.dart';
import 'package:kubera/screens/home_screen.dart';
import 'package:kubera/screens/investments_screen.dart';
import 'package:kubera/screens/savings_screen.dart';
import 'package:kubera/screens/auth_parent_screen.dart';
import 'package:kubera/screens/auth_child_screen.dart';
import 'package:kubera/screens/profile_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _childSessionActive = false;

  // Called after successful authentication.
  void _activateChildSession(bool state) {
    setState(() {
      _childSessionActive = state;
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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for auth state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // If there's no Firebase user, show the parent authentication screen.
        if (!snapshot.hasData) {
          return AuthParentScreen(activateChildSession: _activateChildSession);
        }
        // If user exists but child session is not active, show child auth.
        if (!_childSessionActive) {
          return AuthChildScreen(activateChildSession: _activateChildSession);
        }

        final double paddingSize = MediaQuery.of(context).size.width * 0.12;

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
              indicator: const BoxDecoration(),
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

import 'package:financeapp_app/screens/assets_screen.dart';
import 'package:financeapp_app/screens/auth_screen.dart';
import 'package:financeapp_app/screens/home_screen.dart';
import 'package:financeapp_app/screens/investments_screen.dart';
import 'package:financeapp_app/screens/savings_screen.dart';
import 'package:financeapp_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final authService = Provider.of<AuthService>(context);
    if (!authService.isAuthenticated) return const AuthScreen();

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
              tabs: const [Tab(text: 'Home'), Tab(text: 'Collect'), Tab(text: 'Save'), Tab(text: 'Invest')],
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
        children: [const HomeScreen(), const AssetsScreen(), const SavingsScreen(), const InvestmentsScreen()],
      ),
    );
  }
}

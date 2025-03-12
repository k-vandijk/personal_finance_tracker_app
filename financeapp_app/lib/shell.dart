import 'package:financeapp_app/screens/assets_screen.dart';
import 'package:financeapp_app/screens/auth_screen.dart';
import 'package:financeapp_app/screens/home_screen.dart';
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
    _tabController = TabController(length: 2, vsync: this);
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
              indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
              labelColor: Theme.of(context).colorScheme.onSecondaryContainer,
              unselectedLabelColor: Theme.of(context).colorScheme.onSecondaryContainer,
              dividerColor: Theme.of(context).colorScheme.surface,
              overlayColor: WidgetStateColor.transparent,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: const [Tab(text: 'Home'), Tab(text: 'Assets')],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [const HomeScreen(), const AssetsScreen()],
      ),
    );
  }
}

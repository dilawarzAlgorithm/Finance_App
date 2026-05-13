import 'package:finance_app/widgets/analytics.dart';
import 'package:finance_app/widgets/transactions.dart';
import 'package:flutter/material.dart';

import 'package:finance_app/screens/add_transaction.dart';
import 'package:finance_app/widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance App'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (cntx) => const AddTransactionScreen(),
                ),
              );
              if (mounted) {
                setState(() {});
              }
              ;
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(child: AppDrawer()),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt),
            label: 'Transactions',
          ),
        ],
      ),
      body: <Widget>[Analytics(), Transactions()][_selectedIndex],
    );
  }
}

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
  Key _transactionsKey = UniqueKey();

  void _refreshTransactions() {
    setState(() {
      _transactionsKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance App'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (cntx) => const AddTransactionScreen(),
                ),
              );
              if (result == true && mounted) {
                _refreshTransactions();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: AppDrawer(onTransactionAdded: _refreshTransactions),
      ),
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
      body: <Widget>[
        Analytics(),
        Transactions(key: _transactionsKey),
      ][_selectedIndex],
    );
  }
}

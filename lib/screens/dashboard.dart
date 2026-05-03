import 'package:finance_app/screens/add_transaction.dart';
import 'package:finance_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance App'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (cntx) => AddTransactionScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(child: AppDrawer()),
      body: Center(child: Text('Will Come soon!!')),
    );
  }
}

import 'package:finance_app/core/data/models/transaction_model.dart';
import 'package:finance_app/core/database/database_helper.dart';
import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final db = DatabaseHelper.instance;
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransaction();
  }

  void loadTransaction() async {
    var data = await db.getAllTransactions();
    _transactions = data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (cntx, ind) {
          return ListTile(title: Text(_transactions[ind].title));
        },
      ),
    );
  }
}

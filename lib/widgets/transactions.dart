import 'package:finance_app/core/data/models/category_model.dart';
import 'package:finance_app/core/data/models/transaction_model.dart';
import 'package:finance_app/core/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final db = DatabaseHelper.instance;
  List<TransactionModel> _transactions = [];
  Map<int, CategoryModel> _categoryMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transData = await db.getAllTransactions();
    final catData = await db.getAllCategories();

    final Map<int, CategoryModel> tempMap = {
      for (var cat in catData) cat.id!: cat,
    };

    if (!mounted) return;

    setState(() {
      _transactions = transData;
      _categoryMap = tempMap;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_transactions.isEmpty) {
      return const Center(
        child: Text("No transactions yet. Start adding some!"),
      );
    }

    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (cntx, ind) {
        final tx = _transactions[ind];
        final category = _categoryMap[tx.categoryId];

        return Dismissible(
          key: ValueKey(_transactions[ind]),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            await db.deleteTransaction(tx.id!);
            setState(() {
              _transactions.removeAt(ind);
            });
            if (!mounted) return;
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('${tx.title} dismissed')));
          },
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      category?.color.withAlpha(40) ??
                      Colors.grey.withAlpha(40),
                  child: Icon(
                    category?.icon ?? Icons.help_outline,
                    color: category?.color ?? Colors.grey,
                  ),
                ),
                title: Text(
                  tx.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                trailing: Text(
                  '${tx.type == TransactionType.debit ? "-" : "+"} ₹${tx.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: tx.type == TransactionType.credit
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              const Divider(height: 1),
            ],
          ),
        );
      },
    );
  }
}

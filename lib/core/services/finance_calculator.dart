import 'package:finance_app/core/data/models/transaction_model.dart';

class FinanceStats {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final Map<int, double> categorySpending;

  FinanceStats({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.categorySpending,
  });
}

class FinanceCalculator {
  static FinanceStats calculateStats(List<TransactionModel> transactions) {
    double income = 0.0;
    double expense = 0.0;
    Map<int, double> spendingPerCategory = {};

    for (var tx in transactions) {
      if (tx.type == TransactionType.credit) {
        income += tx.amount;
      } else {
        expense += tx.amount;
        spendingPerCategory[tx.categoryId] =
            (spendingPerCategory[tx.categoryId] ?? 0.0) + tx.amount;
      }
    }

    return FinanceStats(
      totalIncome: income,
      totalExpense: expense,
      balance: income - expense,
      categorySpending: spendingPerCategory,
    );
  }
}

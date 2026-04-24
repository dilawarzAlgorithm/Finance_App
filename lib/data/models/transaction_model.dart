enum TransactionType { credit, debit }

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.categoryId,
  });

  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final int categoryId;
}

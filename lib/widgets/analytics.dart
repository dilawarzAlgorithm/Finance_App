import 'package:finance_app/core/data/models/category_model.dart';
import 'package:finance_app/core/database/database_helper.dart';
import 'package:finance_app/core/services/finance_calculator.dart';
import 'package:finance_app/widgets/charts/finance_chart_painter.dart';
import 'package:finance_app/widgets/charts/summary_bar_chart_painter.dart';
import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics>
    with SingleTickerProviderStateMixin {
  final _db = DatabaseHelper.instance;
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _balance = 0.0;
  double _totalIn = 0.0;
  double _totalOut = 0.0;
  Map<int, double> _categoriesSpending = {};
  Map<int, CategoryModel> _categoryMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadData() async {
    final transData = await _db.getAllTransactions();
    final catData = await _db.getAllCategories();
    final FinanceStats stats = FinanceCalculator.calculateStats(transData);

    final Map<int, CategoryModel> tempMap = {
      for (var cat in catData) cat.id!: cat,
    };

    if (!mounted) return;

    setState(() {
      _categoryMap = tempMap;
      _balance = stats.balance;
      _totalIn = stats.totalIncome;
      _totalOut = stats.totalExpense;
      _categoriesSpending = stats.categorySpending;
      _isLoading = false;
    });

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final spendingEntries = _categoriesSpending.entries.toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Total Net Balance',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${_balance.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Income vs Expenses',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 24),
                  painter: SummaryBarPainter(
                    totalIn: _totalIn,
                    totalOut: _totalOut,
                    animationFactor: _animation.value,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'In: ₹${_totalIn.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Out: ₹${_totalOut.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              'Spending by Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(200, 200),
                    painter: FinanceChartPainter(
                      categorySpending: _categoriesSpending,
                      categoryMap: _categoryMap,
                      animationFactor: _animation.value,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: spendingEntries.length,
              itemBuilder: (cntx, index) {
                final entry = spendingEntries[index];
                final category = _categoryMap[entry.key];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: category?.color.withAlpha(30),
                    child: Icon(
                      category?.icon,
                      color: category?.color,
                      size: 18,
                    ),
                  ),
                  title: Text(category?.name ?? 'Unknown'),
                  trailing: Text(
                    '₹${entry.value.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

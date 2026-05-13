import 'package:finance_app/core/data/models/category_model.dart';
import 'package:finance_app/core/data/models/transaction_model.dart';
import 'package:finance_app/core/database/database_helper.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _dateController = DateTime.now();
  final _dateTextController = TextEditingController();
  TransactionType _ttypeController = TransactionType.debit;
  List<CategoryModel> _availableCategories = [];
  CategoryModel? _selectedCategory;
  bool _isCategoryLoading = true;

  @override
  void initState() {
    super.initState();
    _dateTextController.text =
        '${_dateController.day}/${_dateController.month}/${_dateController.year}';
    _loadCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateTextController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final categories = await DatabaseHelper.instance.getAllCategories();
    setState(() {
      _availableCategories = categories;
      _isCategoryLoading = false;
    });
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final newTransaction = TransactionModel(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        date: _dateController,
        type: _ttypeController,
        categoryId: _selectedCategory!.id!,
      );

      final db = await DatabaseHelper.instance.database;
      await db.insert('transactions', newTransaction.toMap());

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transaction Saved')));

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new transaction'), centerTitle: false),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    maxLength: 50,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter amount';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'Enter valid amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _dateTextController,
                          readOnly: true,
                          decoration: const InputDecoration(labelText: 'Date'),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _dateController,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dateController = pickedDate;

                                _dateTextController.text =
                                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<TransactionType>(
                          initialValue: _ttypeController,
                          decoration: const InputDecoration(
                            labelText: 'Transaction Type',
                          ),

                          items: const [
                            DropdownMenuItem(
                              value: TransactionType.debit,
                              child: Text('Debit'),
                            ),
                            DropdownMenuItem(
                              value: TransactionType.credit,
                              child: Text('Credit'),
                            ),
                          ],

                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _ttypeController = value;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<CategoryModel>(
                          initialValue: _selectedCategory,
                          decoration: InputDecoration(
                            label: (_isCategoryLoading)
                                ? Icon(Icons.loop)
                                : Text('Category'),
                          ),
                          items: _availableCategories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a category' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _titleController.text = '';
                            _amountController.text = '';
                            _dateController = DateTime.now();
                            _dateTextController.text =
                                '${_dateController.day}/${_dateController.month}/${_dateController.year}';
                            _ttypeController = TransactionType.debit;
                            _selectedCategory = null;
                          });
                        },
                        child: Text('Clear'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _saveTransaction,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:finance_app/core/data/models/category_model.dart';
import 'package:finance_app/core/database/database_helper.dart';
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  // Curated lists of popular colors and financial icons
  final List<String> _presetColors = [
    '#EF5350',
    '#EC407A',
    '#AB47BC',
    '#7E57C2',
    '#5C6BC0',
    '#42A5F5',
    '#26A69A',
    '#66BB6A',
    '#D4E157',
    '#FFCA28',
    '#FFA726',
    '#8D6E63',
  ];

  final List<IconData> _presetIcons = [
    Icons.shopping_bag,
    Icons.restaurant,
    Icons.movie,
    Icons.home,
    Icons.medical_services,
    Icons.school,
    Icons.fitness_center,
    Icons.work,
    Icons.flight,
    Icons.build,
    Icons.pets,
    Icons.electrical_services,
    Icons.card_giftcard,
    Icons.celebration,
    Icons.volunteer_activism,
    Icons.payment,
  ];

  String? _selectedColorHex;
  IconData? _selectedIcon;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitCategory() async {
    // 1. Run standard sync form validation (length, empty checks)
    if (!_formKey.currentState!.validate()) return;

    if (_selectedColorHex == null || _selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a color and an icon')),
      );
      return;
    }

    final String enteredName = _nameController.text.trim();

    // 2. NEW: Check database for duplicate category names
    final bool isDuplicate = await DatabaseHelper.instance.doesCategoryExist(
      enteredName,
    );

    if (isDuplicate) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A category named "$enteredName" already exists!'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return; // Stop execution here so it doesn't save
    }

    // 3. Save the category if it's unique
    final newCategory = CategoryModel(
      name: enteredName,
      colorHex: _selectedColorHex!,
      iconCodePoint: _selectedIcon!.codePoint,
    );

    await DatabaseHelper.instance.saveCategory(newCategory);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category added successfully!')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Category')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return 'Please enter at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Select Color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: _presetColors.length,
                itemBuilder: (context, index) {
                  final hex = _presetColors[index];
                  final color = Color(int.parse(hex.replaceFirst('#', '0xff')));
                  final isSelected = _selectedColorHex == hex;

                  return InkWell(
                    onTap: () => setState(() => _selectedColorHex = hex),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Select Icon',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: _presetIcons.length,
                itemBuilder: (context, index) {
                  final icon = _presetIcons[index];
                  final isSelected = _selectedIcon == icon;

                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = icon),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.transparent,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Colors.grey.shade700,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitCategory,
                  child: const Text(
                    'Save Category',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

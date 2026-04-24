class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.iconsPath,
  });
  final int id;
  final String name;
  final double amount;
  final String color;
  final String iconsPath;
}

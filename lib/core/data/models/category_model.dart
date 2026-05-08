class CategoryModel {
  const CategoryModel({
    this.id,
    required this.name,
    required this.color,
    required this.iconsPath,
  });
  final int? id;
  final String name;
  final String color;
  final String iconsPath;

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      color: map['color'] as String,
      iconsPath: map['icon_path'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'color': color, 'icon_path': iconsPath};
  }
}

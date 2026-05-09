import 'package:flutter/material.dart';

class CategoryModel {
  const CategoryModel({
    this.id,
    required this.name,
    required this.colorHex,
    required this.iconCodePoint,
  });

  final int? id;
  final String name;
  final String colorHex;
  final int iconCodePoint;

  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xff')));
  }

  IconData get icon {
    return IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      colorHex: map['colorHex'] as String,
      iconCodePoint: map['icon_code_point'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
      'icon_code_point': iconCodePoint,
    };
  }
}

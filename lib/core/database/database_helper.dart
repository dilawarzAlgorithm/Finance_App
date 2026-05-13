import 'package:finance_app/core/data/models/transaction_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:finance_app/core/data/models/category_model.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return CategoryModel.fromMap(maps[i]);
    });
  }

  Future<List<CategoryModel>> getParticularCategories(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    return List.generate(maps.length, (i) {
      return CategoryModel.fromMap(maps[i]);
    });
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance_vault.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        colorHex TEXT NOT NULL,
        icon_code_point INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE RESTRICT
      )
    ''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final List<CategoryModel> initialCategories = [
      CategoryModel(
        name: 'Food',
        colorHex: '#4CAF50', // Green
        iconCodePoint: Icons.fastfood.codePoint,
      ),
      CategoryModel(
        name: 'Transport',
        colorHex: '#2196F3', // Blue
        iconCodePoint: Icons.directions_car.codePoint,
      ),
      CategoryModel(
        name: 'Leisure',
        colorHex: '#9C27B0', // Purple
        iconCodePoint: Icons.sports_esports.codePoint,
      ),
      CategoryModel(
        name: 'Income',
        colorHex: '#009688', // Teal
        iconCodePoint: Icons.payments.codePoint,
      ),
    ];

    for (var category in initialCategories) {
      await db.insert('categories', category.toMap());
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

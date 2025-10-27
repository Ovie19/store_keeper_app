import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;
  final String _tableName = 'products';

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb('storekeeper.db');
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDb(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// Create the database
  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        imagePath TEXT,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  /// Get all products
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query(_tableName, orderBy: 'id ASC');
  }

  /// Create product
  Future<int> insertProduct(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(_tableName, data);
  }

  /// Update product
  Future<int> updateProduct(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(_tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete Product
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

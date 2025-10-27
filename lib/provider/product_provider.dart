import 'package:flutter/material.dart';
import 'package:store_keeper_app/data/db/db_helper.dart';
import 'package:store_keeper_app/data/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final DbHelper _dbHelper = DbHelper.instance;
  List<Product> _products = [];

  List<Product> get products => _products;

  /// Get all Products
  Future<void> getAllProducts() async {
    final data = await _dbHelper.getAllProducts();
    _products = data.map((product) => Product.fromMap(product)).toList();
    notifyListeners();
  }

  /// Create Product
  Future<void> createProduct(Product product) async {
    await _dbHelper.insertProduct(product.toMap());
    notifyListeners();
    getAllProducts();
  }

  /// Update Product
  Future<void> updateProduct(Product product) async {
    await _dbHelper.updateProduct(product.id!, product.toMap());
    notifyListeners();
    getAllProducts();
  }

  /// Delete Product
  Future<void> deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
    notifyListeners();
    getAllProducts();
  }
}

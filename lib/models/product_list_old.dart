import 'package:flutter/material.dart';
import 'package:my_store/data/database.dart';
import 'package:my_store/models/product.dart';

class ProductListOld with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  bool onlyFavorites = false;

  List<Product> get items {
    if (onlyFavorites) {
      return _items.where((prod) => prod.isFavorite).toList();
    }

    return [..._items];
  }

  void changeOnlyFavorites() {
    onlyFavorites = true;
    notifyListeners();
  }

  void changeAllProducts() {
    onlyFavorites = false;
    notifyListeners();
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeProduct(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_store/data/database.dart';
import 'package:my_store/models/product.dart';
import 'package:my_store/utils/api.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final newProduct = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      title: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      updateProduct(newProduct);
    } else {
      addProduct(newProduct);
    }
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void addProduct(Product product) async {
    try {
      final result = await post(
        Uri.parse('${apiUrl.baseUrl}/products.json'),
        body: jsonEncode({
          'name': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          "isFavorite": product.isFavorite,
        }),
      );

      final id = jsonDecode(result.body)['name'];

      _items.add(
        Product(
          description: product.description,
          id: id,
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title,
          isFavorite: product.isFavorite,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  int get itemsCount {
    return items.length;
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}

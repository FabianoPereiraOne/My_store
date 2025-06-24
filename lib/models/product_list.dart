import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_store/models/product.dart';
import 'package:my_store/utils/api.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Future<void> loadProducts() async {
    try {
      final result = await get(Uri.parse('${apiUrl.baseUrl}/products.json'));

      if (result.body == "null") return;

      final data = jsonDecode(result.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];

      data.forEach((productId, productData) {
        debugPrint(productData['name']);
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['name'],
            description: productData['description'],
            price: productData['price'] is double
                ? productData['price']
                : double.tryParse(productData['price'].toString()),
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });

      _items.clear();
      _items.addAll(loadedProducts);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final newProduct = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      title: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProduct(newProduct);
    }
  }

  Future<bool> updateProduct(Product product) {
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value(true);
  }

  Future<bool> addProduct(Product product) async {
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
    return true;
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

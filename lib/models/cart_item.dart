import 'package:flutter/foundation.dart';

@immutable
class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

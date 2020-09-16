import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String title, double price, String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }

    notifyListeners();
  }

  int get count {
    int count = 0;
    _items.forEach((key, value) {
      count += value.quantity;
    });

    return count;
  }

  double get total {
    double total = 0;
    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });

    return total;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  String authToken;

  void setAuth(String authToken) {
    this.authToken = authToken;
  }

  Future<void> getAndSetOrders() async {
    final url = 'https://shop-app-69c4c.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(url);
    try {
      List<OrderItem> orders = [];
      final loadedOrders = json.decode(response.body) as Map<String, dynamic>;
      if (loadedOrders == null) {
        return;
      }
      loadedOrders.forEach((orderId, orderItem) {
        orders.add(OrderItem(
            amount: orderItem['amout'],
            id: orderItem['id'],
            dateTime: DateTime.parse(orderItem['dateTime']),
            products: (orderItem['products'] as List)
                .map((product) => CartItem(
                    id: product['id'],
                    title: product['title'],
                    price: product['price'],
                    quantity: product['quantity']))
                .toList()));
      });
      _orders = orders;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-app-69c4c.firebaseio.com/orders.json?auth=$authToken';
    final currentDateTime = DateTime.now();

    try {
      var response = await http.post(url,
          body: json.encode({
            'amout': total,
            'dateTime': currentDateTime.toIso8601String(),
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                    })
                .toList()
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: currentDateTime,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    final url = 'https://shop-app-69c4c.firebaseio.com/products/$id.json';
    http
        .patch(url, body: json.encode({'isFavorite': !this.isFavorite}))
        .then((res) {
      if (res.statusCode >= 400) {
        throw new Exception();
      }
    }).catchError((_) {
      this.isFavorite = !this.isFavorite;
      notifyListeners();
    });
    this.isFavorite = !this.isFavorite;
    notifyListeners();
  }
}

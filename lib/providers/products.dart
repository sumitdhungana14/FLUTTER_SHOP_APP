import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Products extends ChangeNotifier {
  List<Product> _products = [];
  String authToken;

  void setValue(String authToken) {
    this.authToken = authToken;
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favProducts {
    return _products.where((element) => element.isFavorite == true).toList();
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-app-69c4c.firebaseio.com/products.json';

    try {
      var res = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageURL': product.imageUrl,
            'isFavorite': product.isFavorite
          }));
      product.id = json.decode(res.body)['name'];
      _products.add(product);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> editProduct(Product product) async {
    var currentProduct = findById(product.id);
    var newProduct = Product(
        id: currentProduct.id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    try {
      final url =
          'https://shop-app-69c4c.firebaseio.com/products/${product.id}.json';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageURL': product.imageUrl,
            'isFavorite': product.isFavorite
          }));
      _products.add(newProduct);
      _products.remove(currentProduct);
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  bool existsById(String id) {
    var exists = false;
    _products.forEach((product) {
      exists = exists || product.id == id;
    });
    return exists;
  }

  Future<void> deleteProduct(String id) async {
    try {
      final url = 'https://shop-app-69c4c.firebaseio.com/products/$id';
      var productIndex = _products.indexWhere((product) => product.id == id);
      var productToDelete = _products[productIndex];
      _products.removeAt(productIndex);
      notifyListeners();
      var res = await http.delete(url);
      if (res.statusCode >= 400) {
        _products.insert(productIndex, productToDelete);
        notifyListeners();
        throw Exception();
      }
    } catch (err) {
      throw (err);
    }
  }

  Future<void> getAndSetProducts() async {
    List<Product> fetchedProducts = [];
    final url = 'https://shop-app-69c4c.firebaseio.com/products.json?auth=$authToken';
    try {
      var res = await http.get(url);
      var importedData = json.decode(res.body) as Map<String, dynamic>;
      importedData.forEach((key, value) {
        fetchedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageURL'],
            isFavorite: value['isFavorite']));
      });
      _products = fetchedProducts;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }
}

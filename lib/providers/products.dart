import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoriteOnly = false;
  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => id == element.id);
  }

  // void showFavoritesOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-shopapp-demo-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString');

    try {
      final response = await http.get(url);
      print(response.body);
      if (response.body == 'null') {
        return;
      }
      url = Uri.parse(
          'https://flutter-shopapp-demo-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      // if (favoriteResponse.body == 'null') {
      //   return;
      // }

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print('extractedData: $extractedData');
      // if (extractedData == null) {
      //   return;
      // }

      final favoriteData = json.decode(favoriteResponse.body);
      print('favoriteData: ${favoriteResponse.body}');

      final loadedProducts = [];
      extractedData.forEach((key, value) {
        print('value: $value');
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            // isFavorite: value['isFavorite'],
            isFavorite:
                favoriteData == null ? false : (favoriteData[key] ?? false)));
      });
      _items = loadedProducts.cast<Product>();
      notifyListeners();
    } catch (error) {
      print('error: $error');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shopapp-demo-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    // return http
    //     .post(
    //   url,
    //   body: json.encode({
    //     // 'id': DateTime.now().toString(),
    //     'title': product.title,
    //     'description': product.description,
    //     'price': product.price,
    //     'imageUrl': product.imageUrl,
    //     'isFavorite': product.isFavorite,
    //   }),
    // )
    //     .then((response) {
    //   // print(json.decode(response.body));
    //   final newProduct = Product(
    //     // id: DateTime.now().toString(),
    //     id: json.decode(response.body)['name'],
    //     title: product.title,
    //     description: product.description,
    //     price: product.price,
    //     imageUrl: product.imageUrl,
    //   );
    //   _items.add(newProduct);
    //   // _items.insert(0, newProduct);
    //   notifyListeners();
    // }).catchError((error) {
    //   print('error: $error');
    //   throw error;
    // });

    // final response = await http.post(
    //   url,
    //   body: json.encode({
    //     // 'id': DateTime.now().toString(),
    //     'title': product.title,
    //     'description': product.description,
    //     'price': product.price,
    //     'imageUrl': product.imageUrl,
    //     'isFavorite': product.isFavorite,
    //   }),
    // );

    // final newProduct = Product(
    //   // id: DateTime.now().toString(),
    //   id: json.decode(response.body)['name'],
    //   title: product.title,
    //   description: product.description,
    //   price: product.price,
    //   imageUrl: product.imageUrl,
    // );
    // _items.add(newProduct);
    // // _items.insert(0, newProduct);
    // notifyListeners();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          // 'id': DateTime.now().toString(),
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          // 'isFavorite': product.isFavorite,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
        // id: DateTime.now().toString(),
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print('error: $error');
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-shopapp-demo-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

      await http.patch(
        url,
        body: json.encode({
          // 'id': DateTime.now().toString(),
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );

      _items[productIndex] = product;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shopapp-demo-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProdcutIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProdcutIndex];

    // _items.removeWhere((element) => element.id == id);
    _items.removeAt(existingProdcutIndex);
    notifyListeners();

    final response = await http.delete(url);
    // print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(existingProdcutIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingProduct = null as Product;
  }
}

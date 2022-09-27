import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/http_exceptiondata.dart';

import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
    String authToken;
  Products(this.authToken,this._items);
  late List<Product> _items = [];
  // = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  // var _showFavoritesOnly = false;
  List<Product> get items {
    //print('hello');
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }
  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findByid(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    //* get is used to get data
    final url = 'https://first-63323-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    // const url = 'https://flutter-update.firebaseio.com/products.json';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach(
        (productId, productData) {
          loadedProducts.add(Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'] ==null ? 0.0 :productData['price'].toDouble() ,
              imageUrl: productData['imageUrl']));
        },
      );
      print('loadProducts ${loadedProducts}');
      _items = loadedProducts;
      notifyListeners();

      print(json.decode(response.body));
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://first-63323-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    //*Post is another future value
    //  http
    //     .post(Uri.parse(url),
    //         body: json.encode({
    //           'title': product.title,
    //           'description': product.description,
    //           'imageUrl': product.imageUrl,
    //           'price': product.price,
    //           'isFavorite': product.isFavorite,
    //         }))
    //     .then((response) //*Then is also return the Future
    //         {
    //   try {
    //     final newProduct = Product(
    //         id: json.decode(response.body)['name'],
    //         title: product.title,
    //         description: product.description,
    //         price: product.price,
    //         imageUrl: product.imageUrl);
    //     _items.add(newProduct);
    //     notifyListeners();
    //   } catch (error) {
    //     print(' This is  : ${error}');
    //     throw error;
    //   }
    //* -----------------------------------------
    //* Await keyword that tells Dart that we want to wait for this operation to finish

    try {
      //todo : Post id used to up the code
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            // 'isFavorite': product.isFavorite,
      
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    // print( json.decode(response.body));

    // _items.insert(0, newProduct); //* add at the start of the list
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final index = _items.indexWhere((prod) {
      // print('1' + prod.id);
      // print('2' + id);

      return prod.id == id;
    });
    if (index >= 0) {
      final url =
          'https://first-63323-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            // 'isFavorite': newProduct.isFavorite,
          }));
      _items[index] = newProduct;
      notifyListeners();
    } else {
      // print('index: ' '${index}');
      // print('...');
    }
  }

  Future<void> deleteProducts(String id) async {
    final url =
        'https://first-63323-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProducy = _items.indexWhere((prod) => prod.id == id);
    var exisingProduct = _items[existingProducy];
    _items.removeAt(existingProducy);
    _items.removeWhere((prod) => prod.id == id);

    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProducy, exisingProduct);
      notifyListeners();
      throw HttpException('Could not delete Product');
    }
    exisingProduct = null as Product;
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/Providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.amount,
      required this.dateTime,
      required this.id,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  Orders(this.authToken,this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final uri = 'https://first-63323-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(Uri.parse(uri));
    final List<OrderItem> loadedOrders = [];
    final extractedData =
        await json.decode(response.body) ;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((OrderId, orderData) {
      loadedOrders.add(OrderItem(
        id: OrderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                price: item['price'] ==0? 0.0 : item['price'].toDouble(),
                quantity: item['quantity'],
                title: item['title'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.toList();
    notifyListeners();
  }

// Future<void>addOrder(List)
  Future<void> addOrder(List<CartItem>? cartProducts, double total) async {
    final uri = 'https://first-63323-default-rtdb.firebaseio.com/orders.json?auth=$authToken';

    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse(uri),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts!
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    print(json.decode(response.body)['name']);
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}

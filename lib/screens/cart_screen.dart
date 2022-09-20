import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/cart.dart'
    show Cart; // Give we know that we only import the Cart Class
import 'package:flutter_application_1/Providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart'
    as ci; // define a prefix to know where file wwe use

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextButton(
                    onPressed: () {
                      
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount);
             print('cartsvcer ${cart.items.values.toList().toString()}');
                           //Listen : false because only dispatch an action
                      cart.clear();//i am listening to changes in cart here but not to changes in orders
                    },
                    child: Text(
                      'ORDER NOW',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, i) {
                return ci.CartItem(
                  id: cart.items.values.toList()[i].id,
                  title: cart.items.values.toList()[i].title,
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                  productId: cart.items.keys.toList()[i],
                ) as Widget;
              },
            ),
          ),
        ],
      ),
    );
  }
}

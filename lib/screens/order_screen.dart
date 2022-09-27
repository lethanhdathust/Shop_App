

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/cart.dart';
import 'package:flutter_application_1/Providers/orders.dart';
import 'package:flutter_application_1/widgets/app_drawar.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const Routname = 'orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  var _isInit = true;
  @override
  void initState() {
    super.initState();

    // Future.delayed(Duration.zero).then((value)  async{
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  // );

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    final a = Provider.of<Cart>(context).items;
    print(a);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        //Build different content based on what your future return
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  print(dataSnapshot.error);
                  return Center(
                    child: Text('An error occurred'),
                  );
                } else {
                  return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, i) {
                        return OrderItems(
                          orderData.orders[i] ,

                        ) ;
                      },
                    ),
                  );
                }
              }
            }));
    // })   _isLoading ?):  ListView.builder(
    //   itemCount: orderData.orders.length,
    //   itemBuilder: (context, i) {
    //     return OrderItems(orderData.orders[i]);
    //   },
    // ),
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/edit_product_screen.dart';
import 'package:flutter_application_1/widgets/app_drawar.dart';
import 'package:flutter_application_1/widgets/user_product_item.dart';

import 'package:provider/provider.dart';
import '../Providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routName = '/user-name';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: ()  {
   
                   Navigator.of(context)
                      .pushNamed(EditProductScreen.routName);
              
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshProducts(context);
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (_, i) {
              return Column(
                children: [
                  UserProductItem(
                    delete: productsData.deleteProducts,
                    id: productsData.items[i].id,
                    imgUrl: productsData.items[i].imageUrl,
                    title: productsData.items[i].title,
                  ),
                  Divider(),
                ],
              );
            },
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}

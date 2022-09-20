import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/products.dart';
import 'package:flutter_application_1/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../Providers/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  ProductsGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFav ? productsData.favoriteItems: productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      //itemBuilder defines how every grid item is built
      itemBuilder: ((context, i) {
        print('grid');
        return ChangeNotifierProvider.value(
          value: products[i], // solution 2
          child: ProductItems(),
        );
      }),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), //gridDelegate :define how the grid generally should be structured
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/cart.dart';
import 'package:flutter_application_1/Providers/product.dart';
import 'package:flutter_application_1/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItems extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItems(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context,
        listen:
            false); //*Access to my cart containers , this give us to access to the nearest provided object of type cart (in the main.dart flie)
    print('item---');

    return Consumer<Product>(
      //Consumer is another way to use provider
      builder: ((context, product, child) {
// *Create a round rectangular clip

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          //*GridTile is the same with the Listtile

          child: GridTile(
            child: GestureDetector(
              onTap: () {
                //*It don't need
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (ctx) {
                //     return ProductDetailScreen(title);
                //   }
                //   )
                //   ,
                // );
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,
                );
              },
              child:Hero(
                tag:product.id ,
                child: FadeInImage(placeholder: const AssetImage('assets/image/product-placeholder.png'),
                image:NetworkImage(
                  product.imageUrl ,
                  ),
                  fit: BoxFit.cover, 
                       
                ),
              ),
            ),
            footer: GridTileBar(
              leading: Consumer<Product>(
                builder: ((context, value, child) => IconButton(
                      icon: Icon(product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () {
                        return product.toggleFavoriteStatus();
                      },
                      color: Theme.of(context).colorScheme.secondary,
                    )),
              ),
              title: Text(
                product.title,
                // style: Theme.of(context).textTheme.titleMedium,

                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black54,
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Add item to cart!',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                },
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        );
      }),
    );
  }
}

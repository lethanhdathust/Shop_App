import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/cart.dart';
import 'package:flutter_application_1/Providers/products.dart';
import 'package:flutter_application_1/screens/cart_screen.dart';
import 'package:flutter_application_1/widgets/app_drawar.dart';
import 'package:flutter_application_1/widgets/badge.dart';
import 'package:flutter_application_1/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../Providers/product.dart';
import '../widgets/products_grid.dart';
import 'package:http/http.dart' as http;

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static const routNamed = 'products-overview';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    print('init');
    //*Can't use context
    // Provider.of<Products>(context).fetchAndSetProducts(); //!  you add listen : false so you can use this here

    // Future.delayed(Duration.zero).then((value) => Provider.of<Products>(context).fetchAndSetProducts()); //* Can Work

    super.initState();
  }

  @override
  void didChangeDependencies() {
    //* Run after the widget has been fully initialized but before build ran for the first time
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
    print('hellooo');
  }

  @override
  Widget build(BuildContext context) {
    print('4');

    // final productsContaiter = Provider.of<Products>(context);
    print('overview');
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showOnlyFavorites = true;
                    // productsContaiter.showFavoritesOnly();
                  } else {
                    // productsContaiter.showAll();
                    _showOnlyFavorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.all,
                    ),
                  ]),
          Consumer<Cart>(
            //this child automatically gets passed into the Badge widget
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              }, // *create the icon button widget here so it will  not rebuild when update UI , when the cart changes
            ),
            builder: (_, cartData, ch) => Badge(
              child: ch as Widget,
              value: cartData.itemCount.toString(),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}

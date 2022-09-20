import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/auth.dart';
import 'package:flutter_application_1/Providers/orders.dart';
import 'package:flutter_application_1/Providers/product.dart';
import 'package:flutter_application_1/screens/auth_screen.dart';
import 'package:flutter_application_1/screens/cart_screen.dart';
import 'package:flutter_application_1/screens/edit_product_screen.dart';
import 'package:flutter_application_1/screens/order_screen.dart';
import 'package:flutter_application_1/screens/product_detail_screen.dart';
import 'package:flutter_application_1/screens/products_ovwerview_screen.dart';
import 'package:flutter_application_1/screens/user_product_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Providers/cart.dart';
import 'Providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('main1');

    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(create: (context) {
 
          return Products('',[] );
        }, update: (ctx, auth, previousProducts) {
          return Products(
            auth.token as String,previousProducts == null ? []:previousProducts.items,
          );
        }),
  
        //  ChangeNotifierProvider.value(
        //   value: Products(),
        // ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Cart();
          },
        ),
      ChangeNotifierProxyProvider<Auth, Orders>(create: (context) {
 
          return Orders('',[] );
        }, update: (ctx, auth, previousOrder) {
          return Orders(
            auth.token as String,previousOrder == null ? []:previousOrder.orders,
          );
        }),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            // primaryColor: Colors.amber[900],
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.yellow,
              accentColor: Color.fromARGB(255, 179, 94, 100),
            ),
            fontFamily:
                GoogleFonts.abhayaLibre(color: Colors.yellow).fontFamily,
            // textTheme: TextTheme(titleLarge: TextStyle(color: Colors.amber)),
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.Routname: (c) => OrdersScreen(),
            UserProductScreen.routName: (context) => UserProductScreen(),
            EditProductScreen.routName: (ctx) => const EditProductScreen(),
            ProductsOverviewScreen.routNamed: ((context) =>
                ProductsOverviewScreen()),
          },
        ),
      ),
    );
  }
}

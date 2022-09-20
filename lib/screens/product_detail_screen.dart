import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // ProductDetailScreen(this.title,this.price);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProducts = Provider.of<Products>(
      context,
      listen:
          false, //*this widget will not rebuild if notifyListeners is called because it is not set up as an active listener   * it is sth you should do if you only need data one time, you want to get data from your global data storage but you're not interested in updates => you don't need to listen
    ).findByid(productId);
    // .items
    // *.firstWhere((prod) => prod.id == productId);* Id of the product i'm looking at  is equal to the productId i got here through my route
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     loadedProducts.title,
      //   ),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,//The appBar will be visible when we scroll 
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProducts.title),
              background:Hero(
                tag:loadedProducts.id,
                child: Image.network(
                  loadedProducts.imageUrl,  
                  fit: BoxFit.cover,
                ),
              ), //This is the part we will see then expand
            ),
          ),
          SliverList(
            //*delegate tell how to render the content of the list
            delegate:SliverChildListDelegate(

            [
              SizedBox(height: 10),
                Text(
                  '\$${loadedProducts.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProducts.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800,),
            ]
          ))
        ],//*This is scrollable areas on the screen
    
      ),
    );
  }
}

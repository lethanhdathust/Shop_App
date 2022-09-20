import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/products.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  final Function delete;
  UserProductItem(
      {required this.id,
      required this.imgUrl,
      required this.title,
      required this.delete});
  @override
  Widget build(BuildContext context) {
    final scaffod = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () async {
              try {
                await Navigator.of(context)
                    .pushNamed(EditProductScreen.routName, arguments: id);
              } catch (E) {
                scaffod
                    .showBodyScrim(true,1);
              }
            },
            icon: Icon(Icons.edit),
            color: Theme.of(context).colorScheme.primary,
          ),
          IconButton(
            onPressed: () {
              return delete(id);
            },
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          ),
        ]),
      ),
    );
  }
}

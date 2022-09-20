import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/product.dart';
import 'package:flutter_application_1/Providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routName = 'edit-Product';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<
      FormState>(); //*Accept we to interact with the state behind the form
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  @override
  void initState() {
    _imageUrlFocusNode.addListener(
        _updateImgUrl); //*Whenever the focus changes ,the _updateImgUrl will be executed
    super.initState();
  }

  @override
  //* run multiple times
  //* Run before the build run
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context)!.settings.arguments == null
          ? "NULL"
          : ModalRoute.of(context)!.settings.arguments as String;
      print('productID' + productID);
      //Check if we have a product and need to update this
      if (productID != 'NULL') {
        final a =
            Provider.of<Products>(context, listen: false).findByid(productID);
        _initValues = {
          'title': a.title,
          'description': a.description,
          'price': a.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,

          'imageUrl': '',
        };
        _imageUrlController.text = a.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //Free up that memory which they occupy and avoid memory leak
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImgUrl);
    super.dispose();
  }

  void _updateImgUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) {
        return;
      }
      if (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) {
        return;
      }
      if (_imageUrlController.text.endsWith('.png') &&
          _imageUrlController.text.endsWith('.ipg') &&
          _imageUrlController.text.endsWith('.pn')) {
        return;
      }
      setState(() {
        // It will update the value because we have an updated value in _imageUrlController and we want to rebuild the screen to reflect the updated value in _imageUrlController because we are in stateFull and must use setState when the data change
      });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!
        .validate(); // * It will trigger all validator in the form widget , it will return true if all validator return true ( null) or return false if at least a validator return a String
    print(isValid);
    if (!isValid) {
      return; // * if a validator is false and then we tap the save button so we stop the _saveForm method here
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    final productId = ModalRoute.of(context)!.settings.arguments == null
        ? "NULL"
        : ModalRoute.of(context)!.settings.arguments as String;
    if (productId != 'NULL') {
     await Provider.of<Products>(context, listen: false)
          .updateProduct(productId, _editedProduct);
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text(
              'STH went wrong',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay!')),
            ],
          ),
        );
      }
      finally{
 setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      }
     
    }
  }

  //* You has to depose focusNode when the state cleared because focusNode are  long-life objects and stick around in memory => lead to a memory leak
  @override
  Widget build(BuildContext context) {
    // var x = Provider.of<Products>(context, listen: false);
    // var m = ModalRoute.of(context)!.settings.arguments == null
    //     ? "NULL"
    //     : ModalRoute.of(context)!.settings.arguments as String;
    // print(_editedProduct.id + '1');
    // print('isloading ${_isLoading}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.one_k_plus))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(children: [
                  // TextField(
                  //   decoration: InputDecoration(labelText: 'hello'),
                  // ),
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provider a value';
                      }
                      return null; //* return nul when no error occurs
                    },
                    onFieldSubmitted: (_) {
                      return FocusScope.of(context).requestFocus(
                          _priceFocusNode); //* Focus to the _descriptionFocusNode when we tap the submitted node
                    },
                    onSaved: (newValue) {
                      //* The value in the textField
                      _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: newValue as String,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct
                              .imageUrl); // Create a product and override the exiting the product instance
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],

                    decoration: const InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number, //Type of keyboard
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      return FocusScope.of(context).requestFocus(
                          _descriptionFocusNode); //* Focus to the _descriptionFocusNode when we tap the submitted node
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) ==
                          null) //* return null if the parse false
                      {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter a number greater than zero';
                      }
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(newValue as String),
                          imageUrl: _editedProduct
                              .imageUrl); // Create a product and override the exiting the product instance
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],

                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    // *textInputAction: TextInputAction.next, // WHen we tap the submitted the focus switch to the next textformfield
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.length < 10) {
                        return 'Please enter at least 10 characters long.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue as String,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct
                              .imageUrl); // Create a product and override the exiting the product instance
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(
                          top: 8,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? const Text('Enter a URL')
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          // initialValue: _initValues['imageUrl'], //!: Can't use initialValue with controller

                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter URL';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Image URL',
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (value) {
                            _saveForm();
                          },
                          onSaved: (newValue) {
                            _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: newValue as String,
                            ); // Create a product and override the exiting the product instance
                          },
                        ),
                      )
                    ],
                  )
                ]),
              ),
            ),
    );
  }
}

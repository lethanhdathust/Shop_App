import 'dart:io';

import 'package:chat_app/widgets/picker/user_image_piecker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this._isLoading);
  final bool _isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    File imageFile,
  ) submitFn;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _password = '';
   File? _userImageFile =null;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submit() {
    final isValid = _formKey.currentState!
        .validate(); //*@this will trigger all the validators of all the text form fields in the form
    FocusScope.of(context).unfocus();
    print('errpor'+ _userImageFile.toString());
    if (_userImageFile == null && _isLogin == false) {
      Scaffold.of(context).showBottomSheet<void>(elevation: 0.1,
          (BuildContext context) {
        return Container(
          height: 100,
          width: double.infinity,
          color: Colors.grey[100],
          child: Center(
              child: Text(
            'Please pick an Image to sign up!',
            style: TextStyle(color: Colors.black),
          )),
        );
      });
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
          _userEmail, _password, _userName, _isLogin, _userImageFile!);
      // use those values to send our auth request
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_isLogin == false) UserUmagePickerState(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || value.contains('@') == false) {
                        return 'Please enter a valid email address!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) {
                      _userEmail = value!;
                      print(_userEmail);
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.length < 4 || value.isEmpty) {
                          return 'Password must be at least 4 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'UserName'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.length < 7 || value.isEmpty) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'PassWord'),
                    obscureText: true,
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup '),
                      onPressed: () {
                        _submit();
                      },
                    ),
                  if (!widget._isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Creat new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
                mainAxisSize: MainAxisSize.min,
              )),
        )),
      ),
    );
  }
}

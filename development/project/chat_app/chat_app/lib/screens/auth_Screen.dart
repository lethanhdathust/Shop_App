import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  var _isloading = false;
  void _SubmiyAuthForm(String email, String password, String username,
      bool isLogin, File file) async {
    UserCredential authResult;
    print('hello' + email);
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(file).then((p0) => null);
        final url = await ref.getDownloadURL();
        print('url'+url );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url':url,
        });
        setState(() {
          _isloading = false;
        });
      }
    } on PlatformException catch (e) {
      // TODO
      var message = 'An error occured , please check  ';
      if (e.message != null) {
        message = e.message!;
      }
      Scaffold.of(context).showBottomSheet(
        (context) => SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isloading = false;
      });
    } catch (E) {
      print('error: ' + E.toString());
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(_SubmiyAuthForm, _isloading),
    );
  }
}

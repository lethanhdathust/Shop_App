import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/http_exceptiondata.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
   late String _token;
  DateTime? _expirytDate;
  late String _userId;
  bool get isAuth {
    print('token' + '$token');
    return token != null;
  }

  String? get token {
    if (_expirytDate != null && _expirytDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDL5WN64rhcYbYbiLutVA33Ekjixj0M3BE';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      // print(responseData);
      // print(responseData['error']['message']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      print('token ' + _token);

      _expirytDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];

      notifyListeners();
      print(json.decode(response.body));
    } catch (e) {
      print(e.toString());
      throw e;
      // TODO
    }
  }

  Future<void> signup(String email, String password) async {
    _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    _authenticate(email, password, 'signInWithPassword');
  }
}

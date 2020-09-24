import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime expiryDate;
  String userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (expiryDate != null &&
        expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDEMWRLcYF-lyIvyIB3tUmi9rfVP8X5KOo';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      if (responseBody['error'] != null) {
        throw Exception(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      userId = responseBody['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDEMWRLcYF-lyIvyIB3tUmi9rfVP8X5KOo';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      if (responseBody['error'] != null) {
        throw Exception(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      userId = responseBody['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
      logoutOnTokenExpiry();
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  void logout() {
    //destroy token on backend
    _token = null;
    expiryDate = null;
    userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void logoutOnTokenExpiry() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    _authTimer = Timer(
        Duration(seconds: expiryDate.difference(DateTime.now()).inSeconds),
        logout);
  }
}

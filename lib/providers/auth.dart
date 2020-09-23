import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;

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
      token = responseBody['idToken'];
      userId = responseBody['localId'];
      expiryDate =
          DateTime.now().add(Duration(seconds: responseBody['expiresIn'] as int));
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
      // token = responseBody['idToken'];
      // userId = responseBody['localId'];
      // expiryDate =
      //     DateTime.now().add(Duration(seconds: responseBody['expiresIn'] as int));
    } catch (err) {
      throw (err);
    }
  }
}

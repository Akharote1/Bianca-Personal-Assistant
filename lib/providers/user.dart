import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier{
  String? accessToken;
  static const BASE_URI = 'http://213.136.88.20:8092';

  UserProvider(){

  }

  login(String email, String password) async {
    var url = Uri.parse('$BASE_URI/login');
    var response = await http.post(url,
        body: {'email': email, 'password': 'password'}
        );
    if(response.statusCode == 200) {

    }
  }


  @override
  void dispose() {
    super.dispose();
  }
}
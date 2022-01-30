import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier{
  String? accessToken;
  Map<String, dynamic> userData = {};

  static const BASE_URI = 'http://213.136.88.20:8092';

  UserProvider(){

  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var url = Uri.parse('$BASE_URI/login');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password})
        );

    if(response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> result = jsonDecode(response.body);
      if(result['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        accessToken = result['access_token'];
        await prefs.setString('access_token', accessToken!);
      }
      return result;
    }
    return {
      'success': false,
      'message': 'Connection error'
    };
  }

  Future<Map<String, dynamic>> verifyToken() async {
    var url = Uri.parse('$BASE_URI/verify-token');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'access_token': accessToken})
    );

    if(response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> result = jsonDecode(response.body);
      if(result['success'] == false) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
      }
      return result;
    }
    return {
      'success': false,
      'message': 'Connection error'
    };
  }

  Future<void> reloadUserData() async {
    var url = Uri.parse('$BASE_URI/user-data');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'access_token': accessToken})
    );

    if(response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> result = jsonDecode(response.body);
      if(result['success'] == true) {
        userData = result['user_data'];
      }
      return;
    }
    return;
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    var url = Uri.parse('$BASE_URI/sign-up');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password})
    );

    if(response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> result = jsonDecode(response.body);
      if(result['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        accessToken = result['access_token'];
        await prefs.setString('access_token', accessToken!);
      }
      return result;
    }
    return {
      'success': false,
      'message': 'Connection error'
    };
  }

  Future<Map<String, dynamic>> updateProfile(String name, int age, int sex) async {
    var url = Uri.parse('$BASE_URI/update-profile');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'full_name': name,
          'age': age,
          'sex': sex,
          'access_token': accessToken
        })
    );

    if(response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    }
    return {
      'success': false,
      'message': 'Connection error'
    };
  }

  Future<Map<String, dynamic>> updateInterests(List<String> interests) async {
    var url = Uri.parse('$BASE_URI/update-interests');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'interests': interests,
          'access_token': accessToken
        })
    );

    if(response.statusCode == 200 || response.statusCode == 400) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    }
    return {
      'success': false,
      'message': 'Connection error'
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');
    return accessToken;
  }
}
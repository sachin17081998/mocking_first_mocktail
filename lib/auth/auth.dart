import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logger {
  void logMessage(String message) {
    print('Logged Messaage:$message');
  }
  void logError(String error){
    print('Error: $error');
  }
}

class Authentication {
  final SharedPreferences localStorage;
  final Logger logger;

  final loginKey = 'isLoggedIn';
  String userName = '';
  Authentication({required this.localStorage, required this.logger});

  void setUserName(String name) {
    if(name.isNotEmpty){
    logger.logMessage(name);
    userName = name;
    }
  }

  String getUsernName() => userName;

  bool isLoggedIn() {
    final status = localStorage.getBool(loginKey);
    return status ?? false;
  }

  Future<bool> setLoginStatus(bool status) async {
    try {
      return await localStorage.setBool(loginKey, status);
    } catch (e) {
      throw Exception('Failed to set status ( Exception:$e)');
    }
  }

  String? validateUserName(String? name) {
    /* validation rules:
    1. 4 <= name_length <= 16
    2. must not contain empty spaces
    */
    if (name == null || name.isEmpty) {
      return 'Enter user name';
    }
    if (name.contains(' ')) {
      return 'user name must not contain empty space';
    }
    if (name.length < 4) {
      return 'name should conatin atleast 4 characters';
    }
    if (name.length > 16) {
      return 'name can conatin atmost 16 characters';
    }
    return null;
  }

  String? validatePassword(String? password) {
    /* validation rule
    1. 8 <= name_length 
    2. must contain atleast 1 number  
    */
    if (password == null || password.isEmpty) {
      return 'Enter Password';
    }
    if (password.length < 4) {
      return 'password should conatin atleast 4 characters';
    }
    if (!password.contains(RegExp(r'\d'))) {
      return 'password must contain atleast 1 number';
    }

    return null;
  }
}

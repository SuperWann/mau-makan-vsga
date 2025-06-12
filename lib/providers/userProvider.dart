import 'package:flutter/material.dart';
import 'package:mau_makan/models/user.dart';
import 'package:mau_makan/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider {
  final UserService _userService = UserService();

  void login(
    BuildContext context,
    TextEditingController username,
    TextEditingController password,
  ) async {
    final String enteredUsername = username.text.trim();
    final String enteredPassword = password.text.trim();

    final UserModel? user = await _userService.getUserByUsername(
      enteredUsername,
    );

    if (user != null && user.password == enteredPassword) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); 
      await prefs.setString('username', enteredUsername); 

      Navigator.pushReplacementNamed(context, '/navbarPage');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau Password salah!')),
      );
    }
  }
}

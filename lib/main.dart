import 'package:flutter/material.dart';
import 'package:mau_makan/pages/addListFood.dart';
import 'package:mau_makan/pages/auth/login.dart';
import 'package:mau_makan/pages/listFood.dart';
import 'package:mau_makan/pages/navbar.dart';
import 'package:mau_makan/pages/profile.dart';
import 'package:mau_makan/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
      routes: {
        LoginPage.nameRoute: (context) => LoginPage(),
        NavbarPage.nameRoute: (context) => NavbarPage(),
        ListFoodPage.nameRoute: (context) => ListFoodPage(),
        AddListFoodPage.nameRoute: (context) => AddListFoodPage(),
        ProfilePage.nameRoute: (context) => ProfilePage(),
      },
    );
  }
}
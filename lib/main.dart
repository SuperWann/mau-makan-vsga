import 'package:flutter/material.dart';
import 'package:mau_makan/pages/addFoodPlace.dart';
import 'package:mau_makan/pages/auth/login.dart';
import 'package:mau_makan/pages/updateFoodPlace.dart';
import 'package:mau_makan/pages/detailFoodPlace.dart';
import 'package:mau_makan/pages/listFoodPlace.dart';
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
        ListFoodPlacePage.nameRoute: (context) => ListFoodPlacePage(),
        AddListFoodPage.nameRoute: (context) => AddListFoodPage(),
        ProfilePage.nameRoute: (context) => ProfilePage(),
        DetailFoodPlacePage.nameRoute: (context) => DetailFoodPlacePage(),
        UpdateFoodPlacePage.nameRoute: (context) => UpdateFoodPlacePage(),
      },
    );
  }
}

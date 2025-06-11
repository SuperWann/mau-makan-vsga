import 'package:flutter/material.dart';
import 'package:we_lost_find/pages/auth/login.dart';
import 'package:we_lost_find/splashScreen.dart';

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
      },
    );
  }
}
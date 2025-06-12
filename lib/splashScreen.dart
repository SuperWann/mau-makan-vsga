import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn =
          prefs.getBool('isLoggedIn') ??
          false; // Default false jika belum login

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(
          context,
          '/navbarPage',
        ); // Arahkan ke halaman utama
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/loginPage',
        ); // Arahkan ke halaman login
      }
    });

    return Scaffold(
      body: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 1),
        builder:
            (context, double value, child) =>
                Opacity(opacity: value, child: child),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 10),
              Text(
                "Mau Makan",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),

      backgroundColor: Color(0xFF2D4F2B),
    );
  }
}

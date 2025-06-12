import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const nameRoute = '/profilePage';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

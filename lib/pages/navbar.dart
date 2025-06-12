import 'package:flutter/material.dart';
import 'package:mau_makan/pages/addListFood.dart';
import 'package:mau_makan/pages/listFood.dart';
import 'package:mau_makan/pages/profile.dart';

class NavbarPage extends StatefulWidget {
  static const nameRoute = '/navbarPage';
  const NavbarPage({super.key});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  int _currentIndex = 0;

  final List<dynamic> _pages = [ListFoodPage(), ProfilePage()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _pages[_currentIndex],
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.09,
              decoration: BoxDecoration(
                color: Color(0xFF2D4F2B), // warna coklat seperti pada gambar
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon(Icons.list_alt_rounded, 0),
                  _navIconAddList(Icons.add, context),
                  _navIcon(Icons.person_outline, 1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.075,
      width: MediaQuery.of(context).size.height * 0.1,
      decoration:
          _currentIndex == index
              ? BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(
                  0.2,
                ), // background putih transparan
                borderRadius: BorderRadius.circular(100), // biar rounded dikit
              )
              : null,
      child: IconButton(
        icon: Icon(
          icon,
          color: _currentIndex == index ? Colors.white : Colors.white70,
        ),
        onPressed: () => _onItemTapped(index),
        iconSize: 30,
      ),
    );
  }

  Widget _navIconAddList(IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/addListFood'),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.white,
          borderRadius: BorderRadius.circular(100), // biar rounded dikit
        ),
        child: IconButton(
          icon: Icon(icon, color: Color(0xFF2D4F2B)),
          onPressed: () => Navigator.pushNamed(context, '/addListFoodPage'),
          iconSize: 30,
        ),
      ),
    );
  }
}

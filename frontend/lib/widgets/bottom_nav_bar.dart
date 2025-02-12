import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, color: Colors.green), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
    );
  }
}

import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/category.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0; 

  // List of pages for navigation
  final List<Widget> _pages = [
    const HomeScreen(),
    JuiceCategoryPage(),
    const CartScreen(),
    const Center(child: Text("Profile Page")), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // Keep state of pages
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, // Handle navigation
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

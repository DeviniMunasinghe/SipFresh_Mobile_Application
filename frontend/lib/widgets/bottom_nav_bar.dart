import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/order_details_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0; // Track selected index

  // List of pages for navigation
  final List<Widget> _pages = [
    const HomeScreen(),
    const OrderDetailsScreen(), // If this is your "Categories" page, update the name accordingly
    const CartScreen(),
    const Placeholder(), // Replace this with ProfileScreen when created
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Categories"), // If this is for order details, update the label
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

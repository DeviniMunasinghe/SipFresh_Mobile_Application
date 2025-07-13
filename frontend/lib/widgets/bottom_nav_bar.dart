import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/category.dart';

class BottomNavBar extends StatefulWidget {
  final String? selectedCategory; //  add this

  const BottomNavBar({super.key, this.selectedCategory});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    if (widget.selectedCategory != null) {
      _selectedIndex = 1; // jump to Categories tab
    }

    _pages = [
      const HomeScreen(),
      JuiceCategoryPage(categoryName: widget.selectedCategory ?? 'Fruit Juice'),
      const CartScreen(),
      const ProfileScreen(),
    ];
  }

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
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
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

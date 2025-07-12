import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/juice_card.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';

class SeeAllItemsScreen extends StatefulWidget {
  const SeeAllItemsScreen({super.key});

  @override
  State<SeeAllItemsScreen> createState() => _SeeAllItemsScreenState();
}

class _SeeAllItemsScreenState extends State<SeeAllItemsScreen> {
  List<Map<String, dynamic>> allItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final data = await ApiService.fetchAllItems();
      setState(() {
        allItems = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available Today",
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF82BA53),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: allItems.length,
              itemBuilder: (_, index) {
                final item = allItems[index];
                return JuiceCardWidget(
                  imagePath: item['item_image'] ??
                      '', // fallback to empty string if null
                  title: item['item_name'] ?? '',
                  price: double.tryParse(
                          item['item_price']?.toString() ?? '0.0') ??
                      0.0,
                  imageHeight: 180, // custom height only for this screen
                );
              },
            ),

      // bottom navbar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const CartScreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()));
          }
        },
      ),
    );
  }
}

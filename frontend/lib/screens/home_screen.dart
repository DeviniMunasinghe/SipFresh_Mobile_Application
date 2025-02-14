import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'order_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")), // App bar with title "Home Page"
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centering the column vertically
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigates to the CartScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: const Text("Go to Cart"), // Button text
            ),
            const SizedBox(height: 10), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                // Navigates to the OrderDetailsScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderDetailsScreen()),
                );
              },
              child: const Text("Go to Order Details"), // Button text
            ),
          ],
        ),
      ),
    );
  }
}

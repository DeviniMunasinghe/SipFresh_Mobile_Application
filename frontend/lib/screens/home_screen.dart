import 'package:flutter/material.dart';
import 'order_details_screen.dart';
import 'category.dart'; // Make sure JuiceCategoryPage is defined here

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                // Navigate to Order Details Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderDetailsScreen(),
                  ),
                );
              },
              child: const Text("Go to Order Details"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Navigate to Juice Category Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JuiceCategoryPage(),
                  ),
                );
              },
              child: const Text("Go to Categories"),
            ),
          ],
        ),
      ),
    );
  }
}

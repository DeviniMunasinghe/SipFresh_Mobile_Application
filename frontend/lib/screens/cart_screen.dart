import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"), // App bar title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button icon
          onPressed: () => Navigator.pop(context), // Go back to the previous screen
        ),
      ),
      body: const Center(
        child: Text("Shopping Cart Page"), // Placeholder text for the cart screen
      ),
    );
  }
}

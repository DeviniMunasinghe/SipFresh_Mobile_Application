import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // Create a CartItem with the required fields
          final newItem = CartItem(
            name: 'Orange Juice',
            price: 175.00,
            quantity: 1,
            imageUrl: 'assets/images/orange_juice.png',
          );

          // Add to cart using the provider method
          Provider.of<CartProvider>(context, listen: false).addToCart(newItem);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to Cart')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Add to Cart'),
      ),
    );
  }
}
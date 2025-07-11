import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class AddToCartButton extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;

  const AddToCartButton({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          final newItem = CartItem(
            name: name,
            price: price,
            quantity: 1,
            imageUrl: imageUrl,
          );

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

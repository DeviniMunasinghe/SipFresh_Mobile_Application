import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class AddToCartButton extends StatelessWidget {
  final int itemId;
  final String name;
  final double price;
  final String imageUrl;

  const AddToCartButton({
    super.key,
    required this.itemId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  Future<void> _sendToBackend(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token'); // ✅ Get token

    if (token == null) {
      print('[AddToCartButton] No token found!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to add items to cart.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = Uri.parse('https://sip-fresh-backend-new.vercel.app/api/cart/add');
    print('[AddToCartButton] Sending POST request...');
    print('Endpoint: $url');
    print('Request Body: {"item_id": $itemId}');
    print('Authorization: Bearer $token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // ✅ Send token here
        },
        body: json.encode({'item_id': itemId}),
      );

      if (response.statusCode == 200) {
        print('[AddToCartButton] Successfully added to cart.');

        final newItem = CartItem(
          id: itemId,
          name: name,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        );

        Provider.of<CartProvider>(context, listen: false).addToCart(newItem);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "$name" to Cart'),
            backgroundColor: Colors.green.shade600,
          ),
        );
      } else {
        print('[AddToCartButton] Backend responded with ${response.statusCode}');
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // width: double.infinity,
      // height: 48,
      child: ElevatedButton(
        onPressed: () => _sendToBackend(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Add to Cart',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

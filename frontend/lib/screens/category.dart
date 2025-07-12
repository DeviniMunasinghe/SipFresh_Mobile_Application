import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';
import '../widgets/product_image.dart';
import '../widgets/product_description.dart';
import '../widgets/product_price.dart';
import '../widgets/add_to_cart_button.dart';

class JuiceCategoryPage extends StatefulWidget {
  const JuiceCategoryPage({super.key});

  @override
  State<JuiceCategoryPage> createState() => _JuiceCategoryPageState();
}

class _JuiceCategoryPageState extends State<JuiceCategoryPage> {
  int _currentIndex = 0;
  List<Item> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJuiceItems();
  }

  Future<void> fetchJuiceItems() async {
    final url = Uri.parse(
      'https://sip-fresh-backend-new.vercel.app/api/items/category/Fruit Juice',
    );

    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((json) => Item.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentProduct = products[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fresh Juices'),
        leading: const BackButton(),
        backgroundColor: Colors.green.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ProductDescription(name: currentProduct.name),
              const SizedBox(height: 12),
              ProductImage(
                imagePaths: products.map((p) => p.imageUrl).toList(),
                onImageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              const SizedBox(height: 12),
              Text(
                currentProduct.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ProductPrice(price: currentProduct.price),
              const SizedBox(height: 20),
              AddToCartButton(
                itemId: currentProduct.id, // 🔁 Now sending to backend
                name: currentProduct.name,
                price: currentProduct.price,
                imageUrl: currentProduct.imageUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

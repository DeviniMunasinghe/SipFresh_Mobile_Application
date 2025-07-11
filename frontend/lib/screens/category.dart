import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Orange Juice',
      'image': 'assets/images/juice1.png',
      'description': 'Fresh and tasty, full of natural sweetness and a splash of vitamin C.',
      'price': 175.0,
    },
    {
      'name': 'Mango Juice',
      'image': 'assets/images/juice2.png',
      'description': 'Packed with tropical flavor and bursting with freshness.',
      'price': 180.0,
    },
    {
      'name': 'Mixed Fruit Juice',
      'image': 'assets/images/juice1.png',
      'description': 'Revitalize your day with this cool and healthy blend.',
      'price': 165.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              ProductDescription(name: currentProduct['name']),
              const SizedBox(height: 12),
              ProductImage(
                imagePaths: products.map((p) => p['image'] as String).toList(),
                onImageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              const SizedBox(height: 12),
              Text(
                currentProduct['description'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ProductPrice(price: currentProduct['price']),
              const SizedBox(height: 20),
              AddToCartButton(
                name: currentProduct['name'],
                price: currentProduct['price'],
                imageUrl: currentProduct['image'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

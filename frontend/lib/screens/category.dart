import 'package:flutter/material.dart';
import '../widgets/product_image.dart';
import '../widgets/product_description.dart';
import '../widgets/product_price.dart';
import '../widgets/add_to_cart_button.dart';

class JuiceCategoryPage extends StatelessWidget {
  const JuiceCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            children: const [
              ProductDescription(name: "Orange Juice"),
              SizedBox(height: 12),
              ProductImage(
                imagePaths: [
                  'assets/images/juice1.png',
                  'assets/images/juice2.png',
                  'assets/images/juice3.png',
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Fresh and tasty, full of natural sweetness and a splash of vitamin C.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ProductPrice(price: 175),
              SizedBox(height: 20),
              AddToCartButton(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

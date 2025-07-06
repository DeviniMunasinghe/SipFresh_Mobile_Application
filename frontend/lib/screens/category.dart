import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class JuiceCategoryPage extends StatefulWidget {
  const JuiceCategoryPage({super.key});

  @override
  _JuiceCategoryPageState createState() => _JuiceCategoryPageState();
}

class _JuiceCategoryPageState extends State<JuiceCategoryPage> {
  final List<Map<String, dynamic>> juiceCategories = [
    {
      "name": "Orange Juice",
      "image": "assets/images/juice1.png",
      "price": 299.43
    },
    {
      "name": "Apple Juice",
      "image": "assets/images/juice2.png",
      "price": 150.99
    },
    {
      "name": "Mango Juice",
      "image": "assets/images/juice1.png",
      "price": 320.00
    },
    {
      "name": "Pineapple Juice",
      "image": "assets/images/juice2.png",
      "price": 275.00
    },
    {
      "name": "Guava Juice",
      "image": "assets/images/juice1.png",
      "price": 250.00
    },
    {
      "name": "Watermelon Juice",
      "image": "assets/images/juice2.png",
      "price": 180.00
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juice Categories'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: juiceCategories.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    juiceCategories[index]["image"]!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    juiceCategories[index]["name"]!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${juiceCategories[index]["price"].toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(
                        CartItem(
                          name: juiceCategories[index]["name"]!,
                          price: juiceCategories[index]["price"],
                          quantity: 1,
                          imageUrl: juiceCategories[index]["image"]!,
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "${juiceCategories[index]['name']} added to cart!"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text("Add to Cart"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

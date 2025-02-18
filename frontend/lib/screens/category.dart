import 'package:flutter/material.dart';

class JuiceCategoryPage extends StatelessWidget {
  final List<Map<String, String>> juiceCategories = [
    {"name": "Orange Juice", "image": "assets/orange_juice.png"},
    {"name": "Apple Juice", "image": "assets/apple_juice.png"},
    {"name": "Mango Juice", "image": "assets/mango_juice.png"},
    {"name": "Pineapple Juice", "image": "assets/pineapple_juice.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juice Categories'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
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
                  SizedBox(height: 10),
                  Text(
                    juiceCategories[index]["name"]!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add your cart logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "${juiceCategories[index]['name']} added to cart!"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Text("Add to Cart"),
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

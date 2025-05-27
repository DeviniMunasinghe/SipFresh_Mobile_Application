import 'package:flutter/material.dart';
import 'order_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF82BA53),
        title: const Text(
          "Sip Fresh",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigates to the OrderDetailsScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrderDetailsScreen()),
                );
              },
              child: const Text("Go to Order Details"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

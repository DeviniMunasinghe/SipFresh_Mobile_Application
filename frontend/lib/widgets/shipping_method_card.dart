import 'package:flutter/material.dart';

class ShippingMethodCard extends StatelessWidget {
  final double totalAmount;

  const ShippingMethodCard({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            const Text(
              "Shipping Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cash on Delivery",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "LKR ${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

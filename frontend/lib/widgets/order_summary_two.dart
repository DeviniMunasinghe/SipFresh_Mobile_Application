import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Items", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/item1.png"),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                const Text("Lorem ipsum dolor sit amet"),
                const Spacer(),
                const Text("LKR 100"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/item2.png"),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                const Text("Lorem ipsum dolor sit amet"),
                const Spacer(),
                const Text("LKR 200"),
              ],
            ),
            const Divider(),
            const Text("Shipping Method", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cash on delivery"),
                  Text("LKR 200"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

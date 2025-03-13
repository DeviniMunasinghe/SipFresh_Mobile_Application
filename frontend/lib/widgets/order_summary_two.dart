import 'package:flutter/material.dart';
import '../models/cart_item.dart'; 

class OrderSummaryTwo extends StatelessWidget {
  final double total;
  final double shippingCharges;
  final double discount;
  final List<CartItem> items;

  const OrderSummaryTwo({
    super.key,
    required this.total,
    required this.shippingCharges,
    required this.discount,
    required this.items,
  });

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
            const Text("Order Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            // Display cart items dynamically
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(item.imageUrl), 
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item.name)), 
                      Text("LKR ${item.price.toStringAsFixed(2)}"), 
                    ],
                  ),
                )),

            const Divider(),

            // Shipping charges
            const Text("Shipping Charges", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Standard Delivery"),
                Text("LKR ${shippingCharges.toStringAsFixed(2)}"),
              ],
            ),

            const SizedBox(height: 10),

            // Discount
            if (discount > 0) ...[
              const Text("Discount", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Applied Discount"),
                  Text("- LKR ${discount.toStringAsFixed(2)}"),
                ],
              ),
            ],

            const Divider(),

            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("LKR ${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

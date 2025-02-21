import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final int totalItems;
  final double shippingCharges;
  final double discount;
  final double total;

  const OrderSummary({super.key, required this.subtotal, required this.totalItems, required this.shippingCharges, required this.discount, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text('LKR${subtotal.toStringAsFixed(2)}')]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('No of items'), Text('$totalItems')]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Shipping charges'), Text('LKR${shippingCharges.toStringAsFixed(2)}')]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Discount'), Text('- LKR${discount.toStringAsFixed(2)}')]),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), Text('LKR${total.toStringAsFixed(2)}')]),
        ],
      ),
    );
  }
}

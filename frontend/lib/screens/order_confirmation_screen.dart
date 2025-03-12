import 'package:flutter/material.dart';
import '../widgets/shipping_address_card.dart'; 
import '../widgets/contact_info_card.dart';
import '../widgets/order_summary_two.dart'; 
import '../models/cart_item.dart'; 

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the order summary
    final double total = 5000.0;
    final double shippingCharges = 200.0;
    final double discount = 100.0;

    // Sample cart items
   final List<CartItem> items = [
  CartItem(name: 'Item 1', price: 1500.0, quantity: 1, imageUrl: 'assets/item1.jpg'),
  CartItem(name: 'Item 2', price: 2000.0, quantity: 2, imageUrl: 'assets/item2.jpg'),
  CartItem(name: 'Item 3', price: 1500.0, quantity: 1, imageUrl: 'assets/item3.jpg'),
];


    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmation"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShippingAddressCard(),
              const SizedBox(height: 20),
              const ContactInfoCard(),
              const SizedBox(height: 10), // Spacing between elements
              const Text(
                "This is my order confirmation",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // Added spacing before the order summary
              OrderSummaryTwo(
                total: total,
                shippingCharges: shippingCharges,
                discount: discount,
                items: items,
              ), // Pass parameters to OrderSummaryTwo
            ],
          ),
        ),
      ),
    );
  }
}

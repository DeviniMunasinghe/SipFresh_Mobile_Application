import 'package:flutter/material.dart';
import '../widgets/shipping_address_card.dart'; 
import '../widgets/contact_info_card.dart';
import '../widgets/order_summary_two.dart'; 
import '../models/cart_item.dart'; 

class OrderConfirmationScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const OrderConfirmationScreen({
    super.key,
    required this.cartItems, // Receive cart items as a parameter
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total dynamically from the cart items
    double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double shippingCharges = 200.0;
    double discount = 100.0;

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
              const SizedBox(height: 10),
              const Text(
                "This is my order confirmation",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              OrderSummaryTwo(
                total: total,
                shippingCharges: shippingCharges,
                discount: discount,
                items: cartItems, // Use the passed cart items
              ),
            ],
          ),
        ),
      ),
    );
  }
}

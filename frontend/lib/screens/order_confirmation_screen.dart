import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/shipping_address_card.dart'; 
import '../widgets/contact_info_card.dart';
import '../widgets/order_summary_two.dart'; 
import '../models/cart_item.dart'; 
import '../providers/cart_provider.dart'; // ✅ Import CartProvider

class OrderConfirmationScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const OrderConfirmationScreen({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context); // ✅ Get CartProvider

    // Get values from the cart provider
    double subtotal = cartProvider.getSubtotal();
    double shippingCharges = 200.0;
    double discount = cartProvider.getDiscount(); // ✅ Fetch discount dynamically
    double total = subtotal + shippingCharges - discount;

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
              const SizedBox(height: 20),
              OrderSummaryTwo(
                total: total,
                shippingCharges: shippingCharges,
                discount: discount, // ✅ Use the discount from CartProvider
                items: cartItems,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

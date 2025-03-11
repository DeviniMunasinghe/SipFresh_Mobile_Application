import 'package:flutter/material.dart';
import '../widgets/shipping_address_card.dart';
import '../widgets/contact_info_card.dart';
import '../widgets/order_summary_two.dart';
import '../widgets/billing_address_selection.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/cart_item.dart'; // Import the CartItem model

class OrderConfirmationScreen extends StatelessWidget {
  final double total;
  final double shippingCharges;
  final double discount;
  final List<CartItem> items; // Cart items list

  const OrderConfirmationScreen({
    super.key,
    required this.total,
    required this.shippingCharges,
    required this.discount,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 10),
              const ContactInfoCard(),
              const SizedBox(height: 10),
              
              // Pass order details to OrderSummaryTwo
              OrderSummaryTwo(
                total: total,
                shippingCharges: shippingCharges,
                discount: discount,
                items: items,
              ),

              const SizedBox(height: 10),
              const BillingAddressSelection(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel order"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Order Completed Successfully!")),
                      );
                    },
                    child: const Text("Complete order"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

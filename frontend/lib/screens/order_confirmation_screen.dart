import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/shipping_address_card.dart';
import '../widgets/contact_info_card.dart';
import '../widgets/order_summary_two.dart';
import '../widgets/billing_address_selection.dart';
import '../widgets/shipping_method_card.dart';
import '../widgets/complete_order_button.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'order_details_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const OrderConfirmationScreen({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Get values from the cart provider
    double subtotal = cartProvider.getSubtotal();
    double shippingCharges = 200.0;
    double discount = cartProvider.getDiscount();
    double total = subtotal + shippingCharges - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.green.shade400,
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
              const SizedBox(height: 20),
              OrderSummaryTwo(
                total: total,
                shippingCharges: shippingCharges,
                discount: discount,
                items: cartItems,
              ),
              const SizedBox(height: 20),
              const BillingAddressSelection(),
              const SizedBox(height: 20),
              ShippingMethodCard(totalAmount: total),
              const SizedBox(height: 20),
              CompleteOrderButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderDetailsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/shipping_address_card.dart';
import '../widgets/contact_info_card.dart';
import '../widgets/order_summary_two.dart';
import '../widgets/billing_address_selection.dart';
import '../widgets/shipping_method_card.dart'; // ✅ Import Shipping Method Card
import '../widgets/complete_order_button.dart'; // ✅ Import Complete Order Button
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const OrderConfirmationScreen({
    super.key,
    required this.cartItems,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Get values from the cart provider
    double subtotal = cartProvider.getSubtotal();
    double shippingCharges = 200.0;
    double discount = cartProvider.getDiscount();
    double total = subtotal + shippingCharges - discount;

    final List<Widget> _pages = [
      const Center(child: Text("Home Page")),
      const Center(child: Text("Categories Page")),
      _buildOrderConfirmationContent(subtotal, shippingCharges, discount, total),
      const Center(child: Text("Profile Page")),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildOrderConfirmationContent(double subtotal, double shippingCharges, double discount, double total) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShippingAddressCard(), // ✅ Shipping Address
            const SizedBox(height: 20),
            const ContactInfoCard(), // ✅ Contact Info
            const SizedBox(height: 20),
            OrderSummaryTwo( // ✅ Order Summary
              total: total,
              shippingCharges: shippingCharges,
              discount: discount,
              items: widget.cartItems,
            ),
            const SizedBox(height: 20),
            const BillingAddressSelection(), // ✅ Billing Address Selection
            const SizedBox(height: 20),
            ShippingMethodCard(totalAmount: total), // ✅ Shipping Method Card
            const SizedBox(height: 20),
            CompleteOrderButton( // ✅ Complete Order Button
              onPressed: () {
                print("Order Completed!");
              },
            ),
          ],
        ),
      ),
    );
  }
}

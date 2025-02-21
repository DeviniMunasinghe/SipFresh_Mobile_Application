import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/order_summary.dart'; // Import the OrderSummary widget

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Calculate values for OrderSummary
    double subtotal = cartProvider.getSubtotal();
    int totalItems = cartProvider.getTotalItems();
    double shippingCharges = 200.0; // Set your fixed or dynamic shipping charge
    double discount = cartProvider.getDiscount(); // Assume your provider calculates it
    double total = subtotal + shippingCharges - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.green[200],
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        item: cartProvider.cartItems[index],
                        onRemove: () => cartProvider.removeFromCart(index),
                        onIncrement: () => cartProvider.incrementQuantity(index),
                        onDecrement: () => cartProvider.decrementQuantity(index),
                      );
                    },
                  ),
                ),
                // Add the Order Summary section
                OrderSummary(
                  subtotal: subtotal,
                  totalItems: totalItems,
                  shippingCharges: shippingCharges,
                  discount: discount,
                  total: total,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Show order success dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Order Successful"),
                          content: const Text("Your order has been placed!"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text("Checkout"),
                  ),
                ),
              ],
            ),
    );
  }
}

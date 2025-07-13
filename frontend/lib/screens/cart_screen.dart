import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/order_summary.dart';
import 'order_confirmation_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final selectedItems = cartProvider.getSelectedItems();
    double subtotal = cartProvider.getSubtotal();
    int totalItems = cartProvider.getTotalItems();
    double shippingCharges = 200.0;
    double discount = cartProvider.getDiscount();
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
                      final item = cartProvider.cartItems[index];
                      return CartItemWidget(
                        item: item,
                        onRemove: () => cartProvider.removeFromCart(index),
                        onIncrement: () => cartProvider.incrementQuantity(index),
                        onDecrement: () => cartProvider.decrementQuantity(index),
                        onToggleSelection: () =>
                            cartProvider.toggleItemSelection(index),
                        isSelected: item.isSelected,
                        onSelected: (bool? value) {
                          cartProvider.toggleItemSelection(index);
                        },
                      );
                    },
                  ),
                ),
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
                    onPressed: selectedItems.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationScreen(
                                  cartItems: selectedItems,
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("Checkout"),
                  ),
                ),
              ],
            ),
    );
  }
}

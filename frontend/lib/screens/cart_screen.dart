import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Show order success dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Order Successful"),
                          content: Text("Your order has been placed!"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
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

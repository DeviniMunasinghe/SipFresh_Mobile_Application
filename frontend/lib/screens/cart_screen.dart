import 'package:flutter/material.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/order_success_dialog.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample list of cart items
  List<CartItem> cartItems = [
    CartItem(
        name: "Orange Juice",
        price: 299.43,
        quantity: 1,
        imageUrl: "assets/images/juice1.png"),
    CartItem(
        name: "Apple",
        price: 150.99,
        quantity: 2,
        imageUrl: "assets/images/juice2.png"),
  ];

  // Function to remove an item
  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  // Function to increment quantity
  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index] =
          cartItems[index].copyWith(quantity: cartItems[index].quantity + 1);
    });
  }

  // Function to decrement quantity
  void _decrementQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index] =
            cartItems[index].copyWith(quantity: cartItems[index].quantity - 1);
      } else {
        _removeItem(index);
      }
    });
  }

  // Function to show order success dialog
  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => const OrderSuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.green[200],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        item: cartItems[index],
                        onRemove: () => _removeItem(index),
                        onIncrement: () => _incrementQuantity(index),
                        onDecrement: () => _decrementQuantity(index),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _showOrderSuccessDialog,
                    child: const Text("Place Order"),
                  ),
                ),
              ],
            ),
    );
  }
}

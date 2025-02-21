import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    int index = _cartItems.indexWhere((cartItem) => cartItem.name == item.name);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
    } else {
      _cartItems.add(item);
    }

    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _cartItems[index] = _cartItems[index].copyWith(
      quantity: _cartItems[index].quantity + 1,
    );
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity - 1,
      );
    } else {
      removeFromCart(index);
    }
    notifyListeners();
  }

  //  Method to calculate the subtotal
  double getSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  //  Method to get total number of items
  int getTotalItems() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Method to calculate discount (Modify based on your logic)
  double getDiscount() {
    return getSubtotal() * 0.1; // Example: 10% discount
  }
}

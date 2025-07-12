import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    int index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
      _updateQuantityBackend(item.id, _cartItems[index].quantity);
    } else {
      _cartItems.add(item);
      _updateQuantityBackend(item.id, item.quantity);
    }

    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
    // Optional: Send DELETE to backend if needed
  }

  void incrementQuantity(int index) {
    final item = _cartItems[index];
    final updatedQuantity = item.quantity + 1;
    _cartItems[index] = item.copyWith(quantity: updatedQuantity);
    notifyListeners();

    _updateQuantityBackend(item.id, updatedQuantity);
  }

  void decrementQuantity(int index) {
    final item = _cartItems[index];

    if (item.quantity > 1) {
      final updatedQuantity = item.quantity - 1;
      _cartItems[index] = item.copyWith(quantity: updatedQuantity);
      notifyListeners();

      _updateQuantityBackend(item.id, updatedQuantity);
    } else {
      removeFromCart(index);
    }
  }

  // ✅ Toggle checkbox selection
  void toggleItemSelection(int index) {
    final current = _cartItems[index];
    _cartItems[index] = current.copyWith(isSelected: !current.isSelected);
    notifyListeners();
  }

  // ✅ Get only selected items
  List<CartItem> getSelectedItems() {
    return _cartItems.where((item) => item.isSelected).toList();
  }

  double getSubtotal() {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int getTotalItems() {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  double getDiscount() {
    return getSubtotal() * 0.1; // 10% discount
  }

  Future<void> _updateQuantityBackend(int itemId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print('[CartProvider] No auth token found.');
      return;
    }

    final url = Uri.parse(
        'https://sip-fresh-backend-new.vercel.app/api/cart/update/$itemId');

    print('[CartProvider] Sending PUT to $url');
    print('[CartProvider] Request body: {"quantity": $quantity}');
    print('[CartProvider] Authorization: Bearer $token');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        print('[CartProvider] Quantity updated for item $itemId');
      } else {
        print('[CartProvider] Failed to update item $itemId. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('[CartProvider] Error updating quantity: $e');
    }
  }
}

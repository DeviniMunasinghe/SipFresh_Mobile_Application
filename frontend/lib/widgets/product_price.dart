import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductPrice extends StatelessWidget {
  final double price; // 👈 changed from String to double

  const ProductPrice({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(
      locale: 'en_LK',
      symbol: 'LKR ',
      decimalDigits: 2,
    ).format(price);

    return Text(
      formattedPrice,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }
}

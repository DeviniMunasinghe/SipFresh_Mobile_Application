import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget {
  final String name;
  const ProductDescription({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
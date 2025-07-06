import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imagePath;
  const ProductImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(left: 0, child: Icon(Icons.arrow_back_ios, color: Colors.green)),
        Positioned(right: 0, child: Icon(Icons.arrow_forward_ios, color: Colors.green)),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'add_to_cart_button.dart';

class JuiceCardWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final double price;
  final VoidCallback? onTap;
  final double imageHeight;
  final int itemId;

  const JuiceCardWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.itemId,
    this.onTap,
    this.imageHeight = 100, // default height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  imagePath,
                  height: imageHeight, // use the parameter
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image);
                  },
                )),

            // Title and Price
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs.${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),
            // const Spacer(),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: AddToCartButton(
                itemId: itemId, // pass the required item ID
                name: title,
                price: price,
                imageUrl: imagePath,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

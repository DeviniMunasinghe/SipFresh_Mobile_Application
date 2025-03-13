import 'package:flutter/material.dart';

class CompleteOrderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CompleteOrderButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Green button
          padding: const EdgeInsets.symmetric(vertical: 14), // Add padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
        child: const Text(
          "Complete Order",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

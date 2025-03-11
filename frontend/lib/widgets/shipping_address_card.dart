import 'package:flutter/material.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: const Text("Shipping Address",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text(
            "Gunawardhana Girls Hostel, Sabaragamuwa University, Belihuloya"),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.green),
          onPressed: () {},
        ),
      ),
    );
  }
}

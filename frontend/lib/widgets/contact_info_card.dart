import 'package:flutter/material.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: const Text("Contact Information",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("+9471399765"),
            Text("amanda@example.com"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.green),
          onPressed: () {},
        ),
      ),
    );
  }
}

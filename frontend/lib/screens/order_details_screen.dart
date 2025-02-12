import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/bottom_nav_bar.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool saveAddress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAE5), // Light green background
      appBar: AppBar(
        backgroundColor: const Color(0xFF86BC5E), // Green app bar
        title: const Text("Order details form"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(icon: Icons.person, hintText: "First Name"),
            CustomTextField(icon: Icons.person, hintText: "Last Name"),
            CustomTextField(icon: Icons.email, hintText: "Email address"),
            CustomTextField(icon: Icons.phone, hintText: "Phone number"),
            CustomTextField(icon: Icons.location_on, hintText: "Address"),
            CustomTextField(icon: Icons.home, hintText: "Zip code"),
            const SizedBox(height: 10),
            Row(
              children: [
                Switch(
                  value: saveAddress,
                  onChanged: (value) {
                    setState(() {
                      saveAddress = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
                const Text("Save this address"),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

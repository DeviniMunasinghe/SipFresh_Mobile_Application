import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/bottom_nav_bar.dart';

// Stateful widget for the Order Details screen
class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}


class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Boolean variable to track if the user wants to save the address
  bool saveAddress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAE5), // Light green background
      appBar: AppBar(
        backgroundColor: const Color(0xFF86BC5E), // Green app bar
        title: const Text("Order details form"), // Title of the app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button icon
          onPressed: () => Navigator.pop(context), // Navigates back when pressed
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the form
        child: Column(
          children: [
            // Custom text fields for user input
            CustomTextField(icon: Icons.person, hintText: "First Name"),
            CustomTextField(icon: Icons.person, hintText: "Last Name"),
            CustomTextField(icon: Icons.email, hintText: "Email address"),
            CustomTextField(icon: Icons.phone, hintText: "Phone number"),
            CustomTextField(icon: Icons.location_on, hintText: "Address"),
            CustomTextField(icon: Icons.home, hintText: "Zip code"),
            const SizedBox(height: 10), // Adds spacing between fields and switch

            // Row containing a switch and text label
            Row(
              children: [
                Switch(
                  value: saveAddress, // Reflects the current state of the switch
                  onChanged: (value) {
                    setState(() {
                      saveAddress = value; // Updates the state when switched
                    });
                  },
                  activeColor: Colors.green, // Switch color when active
                ),
                const Text("Save this address"), // Label for the switch
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(), // Custom bottom navigation bar
    );
  }
}

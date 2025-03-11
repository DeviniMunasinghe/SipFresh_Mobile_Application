import 'package:flutter/material.dart';

class BillingAddressSelection extends StatefulWidget {
  const BillingAddressSelection({super.key});

  @override
  _BillingAddressSelectionState createState() =>
      _BillingAddressSelectionState();
}

class _BillingAddressSelectionState extends State<BillingAddressSelection> {
  int _selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Billing Address",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const Text("All transactions are secure and encrypted"),
        const SizedBox(height: 10),
        RadioListTile(
          value: 0,
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value as int;
            });
          },
          title: const Text("Same as shipping address"),
        ),
        RadioListTile(
          value: 1,
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value as int;
            });
          },
          title: const Text("Use another address"),
        ),
      ],
    );
  }
}

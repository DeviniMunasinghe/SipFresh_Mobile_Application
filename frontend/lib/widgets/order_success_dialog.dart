import 'package:flutter/material.dart';

class OrderSuccessDialog extends StatelessWidget {
  const OrderSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
       
          children: const [
            Text('Your order was successful'),
        
            SizedBox(
              width: 200.0,
              height: 300.0,
              child: Card(child: Text('You will get order within few hours')),
              
            ),
          ],
        ),
      ),




    );
  }
}

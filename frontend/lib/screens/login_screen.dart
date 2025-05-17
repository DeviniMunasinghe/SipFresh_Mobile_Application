import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF82BA53),
        title: Text(
          "Login to SipFresh",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextField(
                decoration: InputDecoration(
                  hintText: "Type your email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

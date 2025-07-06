import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../widgets/social_login_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2EEED),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/Logo.png',
                height: 150,
              ),
              SizedBox(height: 20),

              // welcome text
              Text(
                "Welcome to SipFresh",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF82BA53),
                ),
              ),
              SizedBox(height: 20),

              // login button with navigation to login screen
              OutlinedButton(
                style: ButtonStyle(
                  minimumSize:
                      WidgetStateProperty.all(Size(double.infinity, 50)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  side: WidgetStateProperty.all(
                    BorderSide(color: Color(0xFF82BA53)),
                  ),
                  foregroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white; // Text color on hover
                    }
                    return Color(0xFF82BA53); // Default text color
                  }),
                  backgroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Color(0xFF82BA53); // Fill color on hover
                    }
                    return Colors.transparent; // Default background
                  }),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text("Log In"),
              ),
              SizedBox(height: 10),

              // signup button with navigation to sign up screen
              OutlinedButton(
                style: ButtonStyle(
                  minimumSize:
                      WidgetStateProperty.all(Size(double.infinity, 50)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  side: WidgetStateProperty.all(
                    BorderSide(color: Color(0xFF82BA53)),
                  ),
                  foregroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white; // Text color on hover
                    }
                    return Color(0xFF82BA53); // Default text color
                  }),
                  backgroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Color(0xFF82BA53); // Fill color on hover
                    }
                    return Colors.transparent; // Default background
                  }),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text("Sign Up"),
              ),
              SizedBox(height: 20),

              // separator text for alternative login options
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // social login button for Google
              SocialLoginButton(
                iconPath: 'assets/images/google_icon.png',
                text: "Continue with Google",
                onTap: () {},
              ),
              SizedBox(height: 10),

              // social login button for Facebook
              SocialLoginButton(
                iconPath: 'assets/images/facebook_icon.png',
                text: "Continue with Facebook",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

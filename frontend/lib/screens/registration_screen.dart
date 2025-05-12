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
                height: 120,
              ),

              SizedBox(height: 20),

              // welcome text
              Text(
                "Welcome to SipFresh",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF82BA53),
                ),
              ),

              SizedBox(height: 20),

              // login button with navigation to login screen
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF82BA53),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text("Log In", style: TextStyle(color: Colors.white)),
              ),

              SizedBox(height: 10),

              // signup button with navigation to sign up screen
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Color(0xFF82BA53)),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Color(0xFF82BA53),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // separator text for alternative login options
              Text(
                "---------------Or---------------",
                style: TextStyle(color: Colors.grey),
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

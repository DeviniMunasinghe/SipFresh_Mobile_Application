import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/social_login_button.dart';
import 'signup_screen.dart';
import 'package:frontend/admin/admin_dashboard.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        setState(() => _emailTouched = true);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        setState(() => _passwordTouched = true);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

// Mock success: Navigate to BottomNavBar directly
  // void _handleLogin() async {
  //   setState(() {
  //     _emailTouched = true;
  //     _passwordTouched = true;
  //   });

  //   if (_formKey.currentState!.validate()) {
  //     // Simulate a delay like real network
  //     await Future.delayed(const Duration(seconds: 1));

  //     // Mock success: Navigate to BottomNavBar directly
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const BottomNavBar()),
  //     );
  //   } else {
  //     setState(() => _errorMessage = 'Please enter valid email and password');
  //   }
  // }

  //backend integration

  void _handleLogin() async {
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
    });

    if (_formKey.currentState!.validate()) {
      final url =
          Uri.parse('https://sip-fresh-backend-new.vercel.app/api/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // ✅ Extract the token
        final token = responseData['token'];
        if (token != null) {
          // ✅ Save it in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          print('[Login] Token saved: $token');
        }

        // Extract user role from response data
        final role = responseData['role']; // adjust key if needed

        if (role == 'admin' || role == 'super admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else if (role == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BottomNavBar()),
          );
        } else {
          // Default fallback or show error if role is unexpected
          setState(() {
            _errorMessage = 'Unknown user role: $role';
          });
        }
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Login failed';
        setState(() {
          _errorMessage = error;
        });
      }
    } else {
      setState(() => _errorMessage = 'Please enter valid email and password');
    }

    // Success → Navigate to BottomNavBar
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const BottomNavBar()),
    //     );
    //   } else {
    //     final error = jsonDecode(response.body)['message'] ?? 'Login failed';
    //     setState(() {
    //       _errorMessage = error;
    //     });
    //   }
    // } else {
    //   setState(() => _errorMessage = 'Please enter valid email and password');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF82BA53),
        title: const Text(
          "Login to SipFresh",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              "Welcome back!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Email Field
            const Text("Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              autovalidateMode: _emailTouched
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              decoration: InputDecoration(
                hintText: "Type your email",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$')
                    .hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            // Password Field
            const Text("Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: !_isPasswordVisible,
              autovalidateMode: _passwordTouched
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              decoration: InputDecoration(
                hintText: "Type your password",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Remember me and forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() => _rememberMe = value ?? false);
                      },
                    ),
                    const Text("Remember me",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Forgot password logic
                  },
                  child: const Text("Forgot password?",
                      style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),

            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 10),

            // Login Button
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF82BA53),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  const Text("Log In", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),

            // Divider
            Row(
              children: const [
                Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Or", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider(color: Colors.grey, thickness: 1)),
              ],
            ),
            const SizedBox(height: 20),

            // Social Login
            SocialLoginButton(
              iconPath: 'assets/images/google_icon.png',
              text: "Continue with Google",
              onTap: () {},
            ),
            const SizedBox(height: 10),
            SocialLoginButton(
              iconPath: 'assets/images/facebook_icon.png',
              text: "Continue with Facebook",
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an Account?",
                    style: TextStyle(color: Colors.grey[700])),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text("Sign Up",
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

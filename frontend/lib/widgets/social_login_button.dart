import 'package:flutter/material.dart';

// reusable social login button component
class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 24),
            SizedBox(width: 10),
            Text(text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

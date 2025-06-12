import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: const Color(0xFF1A1A1A), // Consistent app bar color
        iconTheme: const IconThemeData(color: Colors.white), // Ensure back button is visible
      ),
      body: const Center(
        child: Text(
          'Login Screen',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Image.asset(
          'assets/icon.png',
          width: 150,
        ),
      ),
    );
  }
}

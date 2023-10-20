import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo-ctu.png',
          height: 80,
          width: 80,
        ),
      ),
    );
  }
}

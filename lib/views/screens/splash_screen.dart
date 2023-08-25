import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'layout_screen.dart';
import 'login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/logo-ctu.png',
      duration: 1200,
      splashTransition: null,
      nextScreen: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> user) {
          if (user.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (user.hasData && user.data?.email != 'admin@email.com') {
            return const NavbarScreen();
          } else if (user.hasData && user.data?.email == 'admin@email.com') {
            return const NavbarScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

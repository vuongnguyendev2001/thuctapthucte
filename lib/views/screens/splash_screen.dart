import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/login_service.dart';
import 'package:trungtamgiasu/views/screens/layout/layout_giaovu_screen.dart';

import 'layout/layout_screen.dart';
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
          } else if (user.hasData) {
            // print(user.data?.uid);
            return const NavbarScreen();
          } else if (user.hasData && user.data?.email == 'giaovu@gmail.com') {
            return const LayoutGiaovuScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/login_service.dart';
import 'package:trungtamgiasu/views/screens/layout/layout_giangvien_screen.dart';
import 'package:trungtamgiasu/views/screens/layout/layout_giaovu_screen.dart';
import 'package:trungtamgiasu/views/screens/layout/layout_nhanvien_screen.dart';
import 'package:trungtamgiasu/views/screens/splash_screen2.dart';

import 'layout/layout_screen.dart';
import 'login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/logo-ctu.png',
      duration: 1000,
      splashTransition: null,
      nextScreen: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, AsyncSnapshot<User?> user) {
          if (user.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!user.hasData) {
            return const LoginScreen();
          } else {
            return StreamBuilder(
              stream: LoginService().checkUserTypeStream(user.data!.uid),
              builder: (context, AsyncSnapshot<String?> userTypeSnapshot) {
                final userType = userTypeSnapshot.data;
                if (userType == 'Sinh viên') {
                  return const NavbarScreen();
                } else if (userType == 'Nhân viên') {
                  return const LayoutNhanvienScreen();
                } else if (userType == 'Giáo vụ') {
                  return const LayoutGiaovuScreen();
                } else if (userType == 'Giảng viên') {
                  return const LayoutGiangvienScreen();
                } else {
                  return const SplashScreen2();
                }
              },
            );
          }
        },
      ),
    );
  }
}

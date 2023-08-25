import 'package:flutter/material.dart';
import 'package:trungtamgiasu/views/screens/sign_up/sign_up_screen.dart';

import '../views/screens/home/home_screen.dart';
import '../views/screens/layout_screen.dart';
import '../views/screens/login/login_screen.dart';
import '../views/screens/otp/otp_screen.dart';
import '../views/screens/splash_screen.dart';

class RouteManager {
  static const String splashScreen = "/splashScreen";
  static const String loginScreen = "/loginScreen";
  static const String homeScreen = "/homeScreen";
  static const String layoutScreen = "/layoutScreen";
  static const String otpScreen = "/otpScreen";
  static const String signUpScreen = "/signUpScreen";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );
      case otpScreen:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(),
          settings: settings,
        );
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case layoutScreen:
        return MaterialPageRoute(
          builder: (_) => const NavbarScreen(),
          settings: settings,
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('error'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('page_not_found'),
        ),
      );
    });
  }
}

// final route = {
//   RouteManager.loginScreen: (context) => const LoginScreen(),
//   RouteManager.homeScreen: (context) => const HomeScreen()
// };

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:trungtamgiasu/views/screens/account/account_screen.dart';
import 'package:trungtamgiasu/views/screens/agency_staff/approving_internships_screen.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/notification_screen.dart';
import 'package:trungtamgiasu/views/screens/chatbot/chatbot_screen.dart';
import 'package:trungtamgiasu/views/screens/home/home_giangvien_screen.dart';
import 'package:trungtamgiasu/views/screens/home/home_giaovu_screen.dart';
import 'package:trungtamgiasu/views/screens/home/home_nhanvien_screen.dart';
import 'package:trungtamgiasu/views/screens/home/home_screen_main.dart';
import 'package:trungtamgiasu/views/screens/layout/layout_giangvien_screen.dart';
import 'package:trungtamgiasu/views/screens/layout/layout_giaovu_screen.dart';
import 'package:trungtamgiasu/views/screens/layout/layout_nhanvien_screen.dart';
import 'package:trungtamgiasu/views/screens/sign_up/sign_up_screen.dart';
import 'package:trungtamgiasu/views/screens/sinhvien/read_information.dart';
import 'package:trungtamgiasu/views/screens/sinhvien/receipt_form_screen.dart';
import 'package:trungtamgiasu/views/screens/sinhvien/registered_location.dart';
import 'package:trungtamgiasu/views/screens/tim_kiem_dia_diem/tim_kiem_dia_diem.dart';

import '../views/screens/home/home_screen.dart';
import '../views/screens/layout/layout_screen.dart';
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
  static const String chatbotScreen = "/chatbotScreen";
  static const String accountScreen = "/accountScreen";
  static const String layoutGiaovuScreen = "/layoutGiaovuScreen";
  static const String homeGiaovuScreen = "/homeGiaovuScreen";
  static const String homeGiangvienScreen = "/homeGiangvienScreen";
  static const String homeNhanvienScreen = "/homeNhanvienScreen";
  static const String layoutNhanvienScreen = "/layoutNhanvienScreen";
  static const String layoutGiangvienScreen = "/layoutGiangvienScreen";
  static const String timKiemDiaDiem = "/timKiemDiaDiem";
  static const String duyetThucTap = "/duyetThucTap";
  static const String pdfViewer = "/pdfViewer";
  static const String diadiemdadangky = "/diadiemdadangky";
  static const String notificationScreenCanBo = "/notificationScreenCanBo";
    static const String receiptFormScreen = "/receiptFormScreen";
    static const String readInformationStudentScreen = "/readInformationStudentScreen";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case readInformationStudentScreen:
        return MaterialPageRoute(
          builder: (_) => const ReadInformationStudentScreen(),
          settings: settings,
        );
      case receiptFormScreen:
        return MaterialPageRoute(
          builder: (_) => const ReceiptFormScreen(),
          settings: settings,
        );
      case notificationScreenCanBo:
        return MaterialPageRoute(
          builder: (_) => const NotificationScreenCanBo(),
          settings: settings,
        );
      case diadiemdadangky:
        return MaterialPageRoute(
          builder: (_) => const RegisteredLocationScreen(),
          settings: settings,
        );
      case pdfViewer:
        return MaterialPageRoute(
          builder: (_) => const PdfViewer(),
          settings: settings,
        );
      case duyetThucTap:
        return MaterialPageRoute(
          builder: (_) => const ApprovingInternshipsScreen(),
          settings: settings,
        );
      case timKiemDiaDiem:
        return MaterialPageRoute(
          builder: (_) => const TimKiemDiaDiem(),
          settings: settings,
        );
      case layoutNhanvienScreen:
        return MaterialPageRoute(
          builder: (_) => const LayoutNhanvienScreen(),
          settings: settings,
        );
      case layoutGiangvienScreen:
        return MaterialPageRoute(
          builder: (_) => const LayoutGiangvienScreen(),
          settings: settings,
        );
      case homeGiangvienScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeNhanVienScreen(),
          settings: settings,
        );
      case homeGiangvienScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeGiaoVuScreen(),
          settings: settings,
        );
      case homeGiaovuScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeGiaoVuScreen(),
          settings: settings,
        );
      case layoutGiaovuScreen:
        return MaterialPageRoute(
          builder: (_) => const LayoutGiaovuScreen(),
          settings: settings,
        );
      case accountScreen:
        return MaterialPageRoute(
          builder: (_) => const AccountScreen(),
          settings: settings,
        );
      case chatbotScreen:
        return MaterialPageRoute(
          builder: (_) => const ChatbotScreen(),
          settings: settings,
        );
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

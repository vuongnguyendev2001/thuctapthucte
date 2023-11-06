import 'package:flutter/material.dart';
import 'package:trungtamgiasu/views/screens/sinhvien/account_screen.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/notification_screen.dart';
import 'package:trungtamgiasu/views/screens/sinhvien/all_notification_student.dart';
import 'package:trungtamgiasu/views/screens/sinhvien/home_sinhvien_screen.dart';
import 'package:trungtamgiasu/views/screens/tim_kiem_dia_diem/tim_kiem_dia_diem.dart';

import '../sinhvien/notification_student.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({Key? key}) : super(key: key);
  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List pages = [
    const HomeScreen(),
    const TimKiemDiaDiem(),
    const AllNotificationStudent(),
    const AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade400,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.lightBlue.shade900,
        unselectedItemColor: Colors.blueGrey.shade700,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Thông báo"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}

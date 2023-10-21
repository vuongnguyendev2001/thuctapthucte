import 'package:flutter/material.dart';
import 'package:trungtamgiasu/views/screens/account/account_screen.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/notification_screen.dart';
import 'package:trungtamgiasu/views/screens/lecturers/home_giangvien_screen.dart';
import 'package:trungtamgiasu/views/screens/home/home_giaovu_screen.dart';
import 'package:trungtamgiasu/views/screens/lecturers/account_lectures_screen.dart';
import 'package:trungtamgiasu/views/screens/sinhvien/home_sinhvien_screen.dart';

class LayoutGiangvienScreen extends StatefulWidget {
  const LayoutGiangvienScreen({Key? key}) : super(key: key);
  static const String id = 'navbar_screen';
  @override
  State<LayoutGiangvienScreen> createState() => _LayoutGiangvienScreenState();
}

class _LayoutGiangvienScreenState extends State<LayoutGiangvienScreen> {
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List pages = [
    const HomeGiangvienScreen(),
    const NotificationScreenCanBo(),
    const AccountLecturersScreen(),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Thông báo"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}

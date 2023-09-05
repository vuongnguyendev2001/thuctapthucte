import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/services/login_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Thông tin sinh viên',
          style: Style.hometitleStyle.copyWith(color: whiteColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: whiteColor,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await LoginService().handleGoogleSignOut();
                        await LoginService().handleSignOut();
                        await Get.offAllNamed(RouteManager.loginScreen);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.logout_outlined),
                                SizedBox(width: 5),
                                Text(
                                  'Đăng xuất',
                                  style: Style.subtitleStyle,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_outlined,
                              size: 26,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

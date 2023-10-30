import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_image/flutter_svg_image.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';

import '../../../constants/color.dart';
import '../../../constants/currency_formatter.dart';
import '../../../constants/style.dart';
import '../../../controllers/route_manager.dart';
import '../../../services/login_service.dart';

class HomeGiaoVuScreen extends StatefulWidget {
  const HomeGiaoVuScreen({super.key});

  @override
  State<HomeGiaoVuScreen> createState() => _HomeGiaoVuScreenState();
}

class _HomeGiaoVuScreenState extends State<HomeGiaoVuScreen> {
  @override
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      // drawer: Column(children: []),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-ctu.png',
              height: 40,
              width: 40,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Xin chào,', style: Style.subtitleStyle),
                  Text(loggedInUser.userName.toString(),
                      style: Style.titleStyle),
                ],
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleAvatar(
                  radius: 23,
                  child: Image.network(loggedInUser.avatar.toString()),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Button_HomeGiaoVu_Screen(
              icon: const Icon(
                Icons.manage_accounts_outlined,
                color: primaryColor,
              ),
              title: 'Quản lý tài khoản',
              onTap: () {
                Get.toNamed(RouteManager.signUpScreen);
              },
            ),
            const SizedBox(height: 10),
            Button_HomeGiaoVu_Screen(
              icon: const Icon(
                Icons.article_outlined,
                color: primaryColor,
              ),
              title: 'Quản lý học phần',
              onTap: () {
                Get.toNamed(RouteManager.quanlyhocphan);
              },
            ),
            const SizedBox(height: 10),
            Button_HomeGiaoVu_Screen(
              icon: const Icon(
                Icons.work_outline_rounded,
                color: primaryColor,
              ),
              title: 'Quản lý thông báo',
              onTap: () {
                Get.toNamed(RouteManager.managerNotification);
              },
            ),
            const SizedBox(height: 10),
            Button_HomeGiaoVu_Screen(
              icon: const Icon(
                Icons.work_outline_rounded,
                color: primaryColor,
              ),
              title: 'Danh sách sinh viên thực tập',
              onTap: () {
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.toNamed(RouteManager.chatbotScreen);
        },
        backgroundColor: whiteColor,
        child: SvgPicture.asset(
          'assets/icon_svg/question.svg',
          width: 45, // Kích thước chiều rộng
          height: 45, // Kích thước chiều cao
        ),
      ),
    );
  }
}

class Button_HomeGiaoVu_Screen extends StatelessWidget {
  Function()? onTap;
  String? title;
  Icon? icon;
  Button_HomeGiaoVu_Screen({Key? key, this.onTap, this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: whiteColor,
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        icon!,
                        const SizedBox(width: 5),
                        Text(
                          title!,
                          style: Style.subtitlehomeGiaovuStyle,
                        ),
                      ],
                    ),
                    const Icon(
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
    );
  }
}

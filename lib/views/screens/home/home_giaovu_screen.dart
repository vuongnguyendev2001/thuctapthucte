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
    // TODO: implement initState
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
                  child: Image.network(loggedInUser.avatar.toString()),
                  radius: 23,
                ),
              ),
              const SizedBox(width: 10),
              //     InkWell(
              //       onTap: () async {
              //         await LoginService().handleGoogleSignOut();
              //         await LoginService().handleSignOut();
              //         await Get.offAllNamed(RouteManager.loginScreen);
              //       },
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: Container(
              //           height: 37,
              //           width: 37,
              //           color: cardsLite,
              //           child: Image(
              //             image: SvgImage.asset(
              //               'assets/icon_svg/Buy.svg',
              //               currentColor: blackColor,
              //             ),
              //             height: 18,
              //             width: 18,
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 15),
              //     InkWell(
              //       onTap: () {
              //         print(user);
              //       },
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: Container(
              //           height: 37,
              //           width: 37,
              //           color: cardsLite,
              //           child: Image(
              //             image: SvgImage.asset(
              //               'assets/icon_svg/Notification.svg',
              //               currentColor: blackColor,
              //             ),
              //             height: 18,
              //             width: 18,
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 20),
            ],
          ),
        ],
      ),

      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: accentColor,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 80,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icon_svg/account.svg',
                                width: 45, // Kích thước chiều rộng
                                height: 45, // Kích thước chiều cao
                              ),
                              SizedBox(
                                height: 60,
                                child: Text(
                                  'Cập nhật thông tin tài khoản',
                                  style: Style.homesubtitleStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await LoginService().checkUserType();
                          },
                          child: SizedBox(
                            width: 78,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icon_svg/list.svg',
                                  width: 45, // Kích thước chiều rộng
                                  height: 45, // Kích thước chiều cao
                                ),
                                SizedBox(
                                  child: Text(
                                    'Cập nhật địa điểm thực tập',
                                    style: Style.homesubtitleStyle,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 78,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icon_svg/note.svg',
                                width: 45, // Kích thước chiều rộng
                                height: 45, // Kích thước chiều cao
                              ),
                              SizedBox(
                                height: 60,
                                child: Text(
                                  'Cập nhật danh sách giảng viên',
                                  style: Style.homesubtitleStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 80,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icon_svg/account.svg',
                                width: 45, // Kích thước chiều rộng
                                height: 45, // Kích thước chiều cao
                              ),
                              SizedBox(
                                height: 60,
                                child: Text(
                                  'Xét duyệt địa điểm thực tập',
                                  style: Style.homesubtitleStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await LoginService().checkUserType();
                          },
                          child: SizedBox(
                            width: 78,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icon_svg/list.svg',
                                  width: 45, // Kích thước chiều rộng
                                  height: 45, // Kích thước chiều cao
                                ),
                                SizedBox(
                                  child: Text(
                                    'Phân công giảng viên',
                                    style: Style.homesubtitleStyle,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 78,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icon_svg/note.svg',
                                width: 45, // Kích thước chiều rộng
                                height: 45, // Kích thước chiều cao
                              ),
                              SizedBox(
                                height: 60,
                                child: Text(
                                  'Cập nhật danh sách sinh viên',
                                  style: Style.homesubtitleStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteManager.chatbotScreen);
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

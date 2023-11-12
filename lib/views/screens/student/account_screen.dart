// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/services/login_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  UserModel loggedInUser = UserModel();
  String? email, avatarUser, name;
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      // loggedInUser = updatedUser;
      avatarUser = updatedUser.avatar;
      email = updatedUser.email;
    });
  }

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
            FutureBuilder<UserModel>(
              future: getUserInfo(loggedInUser),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      user.avatar != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: CircleAvatar(
                                  radius: 35,
                                  child: Image.network(user.avatar.toString()),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: CircleAvatar(
                                  radius: 35,
                                  child: Image.asset('assets/images/user.png'),
                                ),
                              ),
                            ),
                      //           const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_circle_outlined,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                user.userName!,
                                style: Style.titleStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.article_outlined,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 5),
                              RichText(
                                text: TextSpan(
                                  text: 'Lớp: ',
                                  style: Style.titleStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: user.idClass,
                                        style: Style.titleStyle.copyWith(
                                          color: primaryColor,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 5),
                              RichText(
                                text: TextSpan(
                                  text: 'Gmail: ',
                                  style: Style.titleStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: user.email,
                                        style: Style.titleStyle.copyWith(
                                          color: primaryColor,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
            const SizedBox(height: 15),
            Button_Account_Screen(
              title: 'Thông tin cá nhân',
              icon: const Icon(
                Icons.account_box_outlined,
                color: primaryColor,
              ),
              onTap: () async {
                Get.toNamed(RouteManager.readInformationStudentScreen);
              },
            ),
            // const SizedBox(height: 10),
            // Button_Account_Screen(
            //   title: 'Thông tin giảng viên hướng dẫn',
            //   icon: const Icon(
            //     Icons.article_outlined,
            //     color: primaryColor,
            //   ),
            //   onTap: () async {},
            // ),
            // const SizedBox(height: 10),
            // Button_Account_Screen(
            //   title: 'Thông tin cán bộ hướng dẫn',
            //   icon: const Icon(
            //     Icons.supervised_user_circle_outlined,
            //     color: primaryColor,
            //   ),
            //   onTap: () async {},
            // ),
            const SizedBox(height: 10),
            Button_Account_Screen(
              title: 'Đăng xuất',
              icon: const Icon(
                Icons.logout_outlined,
                color: primaryColor,
              ),
              onTap: () async {
                await LoginService().handleGoogleSignOut();
                await LoginService().handleSignOut();
                await Get.offAllNamed(RouteManager.loginScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: background,
  //     appBar: AppBar(
  //       backgroundColor: primaryColor,
  //       automaticallyImplyLeading: false,
  //       title: Text(
  //         'Thông tin sinh viên',
  //         style: Style.hometitleStyle.copyWith(color: whiteColor),
  //       ),
  //       centerTitle: true,
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           avatarUser != null
  //               ? Padding(
  //                   padding: const EdgeInsets.only(left: 10),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(35),
  //                     child: CircleAvatar(
  //                       radius: 35,
  //                       child: Image.network(avatarUser.toString()),
  //                     ),
  //                   ),
  //                 )
  //               : Padding(
  //                   padding: const EdgeInsets.only(left: 10),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(35),
  //                     child: CircleAvatar(
  //                       radius: 35,
  //                       child: Image.asset('assets/images/user.png'),
  //                     ),
  //                   ),
  //                 ),
  //           const SizedBox(width: 10),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Row(
  //               //   children: [
  //               //     const Icon(
  //               //       Icons.account_circle_outlined,
  //               //       color: primaryColor,
  //               //     ),
  //               //     const SizedBox(width: 5),
  //               //     Text(
  //               //       loggedInUser.userName!,
  //               //       style: Style.titleStyle,
  //               //     ),
  //               //   ],
  //               // ),
  //               const SizedBox(height: 2),
  //               Row(
  //                 children: [
  //                   const Icon(
  //                     Icons.article_outlined,
  //                     color: primaryColor,
  //                   ),
  //                   const SizedBox(width: 5),
  //                   // Text(
  //                   //   'Lớp: ${loggedInUser.idClass!}',
  //                   //   style: Style.titleStyle,
  //                   // ),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   const Icon(
  //                     Icons.email_outlined,
  //                     color: primaryColor,
  //                   ),
  //                   const SizedBox(width: 5),
  //                   Text(
  //                     'Gmail: $email',
  //                     style: Style.titleStyle,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 15),
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: Container(
  //               color: whiteColor,
  //               child: Column(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () async {
  //                       await LoginService().handleGoogleSignOut();
  //                       await LoginService().handleSignOut();
  //                       await Get.offAllNamed(RouteManager.loginScreen);
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.all(10),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Icon(Icons.logout_outlined),
  //                               SizedBox(width: 5),
  //                               Text(
  //                                 'Đăng xuất',
  //                                 style: Style.subtitleStyle,
  //                               ),
  //                             ],
  //                           ),
  //                           Icon(
  //                             Icons.keyboard_arrow_right_outlined,
  //                             size: 26,
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class Button_Account_Screen extends StatelessWidget {
  Function()? onTap;
  String? title;
  Icon? icon;
  Button_Account_Screen({Key? key, this.onTap, this.title, this.icon})
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
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        icon!,
                        const SizedBox(width: 5),
                        Text(
                          title!,
                          style: Style.subtitleStyle,
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

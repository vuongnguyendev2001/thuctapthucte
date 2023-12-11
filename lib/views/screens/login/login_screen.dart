import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/services/firebase_api.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/snack_bar_type.dart';
import '../../../constants/style.dart';
import '../../../constants/ui_helper.dart';
import '../../../controllers/route_manager.dart';
import '../../../models/user/user_model.dart';
import '../../../services/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String verify = "";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final TextEditingController countryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String gmail = '@gmail.com';
  final TextEditingController passwordController =
      TextEditingController(text: '123456');
  var phone = "";
  final GlobalKey<FormState> _formKeyOtp = GlobalKey();
  final _auth = FirebaseAuth.instance;
  bool? isShowPass;
  // UserModel currentUser = getUserInfo();
  @override
  void initState() {
    super.initState();
    countryController.text = "+84";
    isShowPass = true;
    // currentUser = getUserInfo();
    // print(currentUser.email);
  }

  CollectionReference companiesCollection =
      FirebaseFirestore.instance.collection('companies');
  Future<CompanyIntern?> getInformationCompany(String? userID) async {
    QuerySnapshot querySnapshot = await companiesCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        CompanyIntern companyIntern = CompanyIntern.fromMap(data);
        if (companyIntern.idUserCanBo == userID) {
          return companyIntern;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UIHelper.showFlushbar(
            message: 'Vui lòng đăng nhập để sử dụng tính năng',
            snackBarType: SnackBarType.error,
          );
        },
        backgroundColor: whiteColor,
        child: SvgPicture.asset(
          'assets/icon_svg/question.svg',
          width: 45, // Kích thước chiều rộng
          height: 45, // Kích thước chiều cao
        ),
      ),
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.06),
              Text('Xin chào !', style: Style.hometitleStyle),
              const SizedBox(height: 10),
              Text('Chào mừng bạn đến hệ thống thực tập',
                  style: Style.hometitleStyle),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo-ctu.png',
                  height: 120,
                  width: 120,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 7),
                height: 55,
                decoration: BoxDecoration(
                    color: cardsLite,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle_outlined,
                        color: primaryColor),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          if (!(value?.trim().isPhoneNumber ?? false)) {
                            return 'Số điện thoại không hợp lệ';
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Mã số",
                          hintStyle: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 7),
                height: 55,
                decoration: BoxDecoration(
                    color: cardsLite,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/images/icons/vietnam.png',
                    //   height: 18,
                    //   width: 18,
                    // ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // SizedBox(
                    //   width: 40,
                    //   child: TextField(
                    //     controller: countryController,
                    //     keyboardType: TextInputType.number,
                    //     readOnly: true,
                    //     decoration: const InputDecoration(
                    //         border: InputBorder.none,
                    //         hintStyle: TextStyle(
                    //           fontWeight: FontWeight.w400,
                    //           fontSize: 14,
                    //           color: priceColor,
                    //         )),
                    //   ),
                    // ),
                    // const Text(
                    //   "|",
                    //   style: TextStyle(fontSize: 33, color: Colors.grey),
                    // ),
                    const Icon(Icons.password_outlined, color: primaryColor),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          // if (!(value?.trim().isPhoneNumber ?? false)) {
                          //   return 'Số điện thoại không hợp lệ';
                          // }
                          return null;
                        },
                        // controller: emailController,
                        keyboardType: TextInputType.text,
                        obscureText: isShowPass!,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Mật khẩu",
                          hintStyle: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isShowPass == true) {
                          setState(() {
                            isShowPass = false;
                          });
                        } else {
                          setState(() {
                            isShowPass = true;
                          });
                        }
                      },
                      child: Icon(
                        isShowPass == true
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  /// Google
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await Loading().isShowLoading();
                          await LoginService().signInAccount(
                              emailController.text + gmail,
                              passwordController.text);
                          FirebaseAuth.instance.authStateChanges().listen(
                            (User? user) async {
                              if (user != null) {
                                print(user.uid);
                                final userType = await LoginService()
                                    .checkUserType(user.uid);
                                CompanyIntern? companyIntern =
                                    await getInformationCompany(user.uid);
                                if (userType == 'Giáo vụ') {
                                  await Get.offAllNamed(
                                      RouteManager.layoutGiaovuScreen);
                                } else if (userType == 'Sinh viên') {
                                  await Get.offAllNamed(
                                      RouteManager.layoutScreen);
                                } else if (userType == 'Giảng viên') {
                                  await Get.offAllNamed(
                                      RouteManager.layoutGiangvienScreen);
                                } else if (userType == 'Nhân viên') {
                                  if (companyIntern == null) {
                                    await Get.toNamed(
                                        RouteManager.waitingAccept);
                                  } else {
                                    await Get.offAllNamed(
                                        RouteManager.layoutNhanvienScreen);
                                  }
                                }
                              }
                            },
                          );
                        } catch (e) {
                          UIHelper.showFlushbar(
                            message: 'Có lỗi xãy ra. Vui lòng thử lại !',
                            snackBarType: SnackBarType.warning,
                          );
                        } finally {
                          await Loading().isOffShowLoading();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(Get.width, 44),
                        elevation: 0.0,
                        backgroundColor: primaryColor,
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Đăng nhập',
                        // 'login'.tr.capitalize,
                        style: Style.titleStyle.copyWith(color: backgroundLite),
                      ),
                    ),
                  ),
                ],
              ),

              // /// Or
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  const SizedBox(width: 8.0),
                  Text(
                    'hoặc'.tr.toUpperCase(),
                    style: Style.priceStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Expanded(child: Divider()),
                ],
              ),

              // /// Social login
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // print(currentUser.email);
                        Get.toNamed(RouteManager.signUpCompany);
                        // try {
                        // await Loading().isShowLoading();
                        //   // await LoginService().sendOTP(emailController.text);
                        // } catch (e) {
                        //   UIHelper.showFlushbar(
                        //     message: 'Có lỗi xãy ra. Vui lòng thử lại !',
                        //     snackBarType: SnackBarType.warning,
                        //   );
                        // } finally {
                        //   await Loading().isOffShowLoading();
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(Get.width, 44),
                        elevation: 0.0,
                        backgroundColor: accentColor,
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Đăng kí tài khoản công ty',
                        // 'login'.tr.capitalize,
                        style: Style.titleStyle.copyWith(color: backgroundLite),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  /// Google
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await Loading().isShowLoading();
                          await LoginService().handleGoogleSignIn();
                          if (LoginService().checkGoogleSignInStatus() ==
                              true) {
                            await LoginService().postDetailsToFirestore();
                          }
                          Get.offAllNamed(RouteManager.layoutScreen);
                        } catch (e) {
                          UIHelper.showFlushbar(
                            message: 'Có lỗi xãy ra. Vui lòng thử lại !',
                            snackBarType: SnackBarType.warning,
                          );
                        } finally {
                          await Loading().isOffShowLoading();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(Get.width, 44),
                        elevation: 0.0,
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icons/google_logo.png',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Tiếp tục với Google',
                            // 'login'.tr.capitalize,
                            style: Style.titleStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Row(
              //   children: [
              //     /// Google
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () async {},
              //         style: ElevatedButton.styleFrom(
              //           minimumSize: Size(Get.width, 44),
              //           elevation: 0.0,
              //           backgroundColor: kBackgroundFB,
              //           side: const BorderSide(
              //             color: Colors.grey,
              //             width: 1.0,
              //           ),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10.0),
              //           ),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Image.asset(
              //               'assets/images/icons/facebook_logo.png',
              //               width: 18,
              //               height: 18,
              //             ),
              //             const SizedBox(width: 8.0),
              //             Text(
              //               'Tiếp tục với Facebook'.tr,
              //               // 'login'.tr.capitalize,
              //               style: Style.titleStyle
              //                   .copyWith(color: backgroundLite),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bạn cần hỗ trợ? ',
                    style: Style.subtitleStyle,
                  ),
                  Text(
                    'Liên hệ ngay',
                    style: Style.subtitleStyle.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

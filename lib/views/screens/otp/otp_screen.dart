import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/ui_helper.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/views/screens/login/login_screen.dart';

import '../../../constants/color.dart';
import '../../../constants/enums/snack_bar_type.dart';
import '../../../constants/style.dart';
import '../../../controllers/route_manager.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final parsePhone = Get.arguments ?? '';
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: blackColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primaryButtonColor),
      borderRadius: BorderRadius.circular(20),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: greyShade,
      ),
    );
    var code = "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/img1.png',
              //   width: 150,
              //   height: 150,
              // ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Xác nhận Mã OTP",
                style: Style.hometitleStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Một mã xác thực gồm 6 chữ số đã được gửi đến số điện thoại $parsePhone",
                style: Style.subtitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Nhập mã để tiếp tục",
                style: Style.subtitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Pinput(
                autofocus: true,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                onChanged: (value) {
                  code = value;
                },
                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: dashTeal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    try {
                      await Loading().isShowLoading();
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: LoginScreen.verify,
                        smsCode: code,
                      );
                      await auth.signInWithCredential(credential);
                      if (auth.currentUser!.email == null ||
                          auth.currentUser!.displayName == null) {
                        UserModel user = UserModel(
                          phoneNumber: parsePhone
                        );
                        Get.offAndToNamed(
                          RouteManager.signUpScreen,
                          arguments: user,
                        );
                      } else {
                        Get.offAllNamed(RouteManager.layoutScreen);
                      }
                    } catch (e) {
                      UIHelper.showFlushbar(
                        message: 'Mã OTP chưa chính xác! Vui lòng kiểm tra lại',
                        snackBarType: SnackBarType.error,
                      );
                    } finally {
                      await Loading().isOffShowLoading();
                    }
                  },
                  child: Text(
                    "Xác nhận",
                    style: Style.titleStyle.copyWith(color: backgroundLite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

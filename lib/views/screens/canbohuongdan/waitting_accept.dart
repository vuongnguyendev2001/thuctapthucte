import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/services/login_service.dart';

class WaitingAccept extends StatelessWidget {
  const WaitingAccept({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            LoginService().handleGoogleSignOut();
            LoginService().handleSignOut();
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: primaryColor,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tài khoản ${currentUser?.email} chưa được phê duyệt',
            style: Style.subtitleBlackGiaovuStyle,
          ),
          Text(
            'Vui lòng chờ được phê duyệt !',
            style: Style.subtitleBlackGiaovuStyle,
          ),
          Image.asset(
            'assets/images/nodata2.jpg',
          )
        ],
      ),
    );
  }
}

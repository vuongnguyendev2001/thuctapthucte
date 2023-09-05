import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/enums/snack_bar_type.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/views/widgets/custom_text_form_field.dart';

import '../../../constants/style.dart';
import '../../../constants/ui_helper.dart';
import '../../../services/login_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

const List<String> list = <String>[
  'Sinh viên',
  'Giảng viên',
  'Giáo vụ',
  'Nhân viên'
];

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String dropdownValue = list.first;
  // UserModel userModel = Get.arguments;
  @override
  void initState() {
    // if (userModel.phoneNumber != null) {
    //   phoneController.text = userModel.phoneNumber.toString();
    //   nameController.text = "";
    //   emailController.text = "";
    //   addressController.text = "";
    // }
    // if (userModel.phoneNumber == null) {
    //   phoneController.text = "";
    //   nameController.text = userModel.userName.toString();
    //   emailController.text = userModel.email.toString();
    //   addressController.text = "";
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        title: Text(
          'Đăng ký tài khoản',
          style: Style.hometitleStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              children: [
                CustomTextFormField(
                  controller: emailController,
                  hintText: 'Nhập email đăng nhập',
                  iconData: Icons.email_outlined,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: passwordController,
                  obscureText: true,
                  hintText: 'Nhập mật khẩu',
                  iconData: Icons.password_outlined,
                ),
                const SizedBox(height: 10),
                // CustomTextFormField(
                //   controller: nameController,
                //   hintText: 'Nhập tên',
                //   iconData: Icons.abc_outlined,
                // ),
                // const SizedBox(height: 10),
                // CustomTextFormField(
                //   controller: phoneController,
                //   hintText: 'Nhập số điện thoại',
                //   iconData: Icons.phone_android_outlined,
                // ),
                // const SizedBox(height: 10),
                // CustomTextFormField(
                //   controller: addressController,
                //   hintText: 'Nhập địa chỉ',
                //   iconData: Icons.location_city_outlined,
                // ),
                // const SizedBox(height: 20),
                DropdownMenu<String>(
                  width: Get.width * 0.9,
                  label: const Text('Loại tài khoản'),
                  leadingIcon: Icon(Icons.person),
                  textStyle: Style.subtitleStyle,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                      print(dropdownValue);
                    });
                  },
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Loading().isShowLoading();
                      await LoginService().signUpAccount(
                        emailController.text,
                        passwordController.text,
                      );
                      await LoginService().signInAccount(
                        emailController.text,
                        passwordController.text,
                      );
                      await LoginService()
                          .typeAccount(dropdownValue, emailController.text);
                      Get.back();
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
                    minimumSize: Size(Get.width, 54),
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
                    'Đăng kí'.toUpperCase(),
                    // 'login'.tr.capitalize,
                    style: Style.titleStyle.copyWith(color: backgroundLite),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

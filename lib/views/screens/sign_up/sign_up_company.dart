import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/enums/snack_bar_type.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/views/screens/mentor/receipt_form_screen.dart';
import 'package:trungtamgiasu/views/widgets/custom_text_form_field.dart';

import '../../../constants/style.dart';
import '../../../constants/ui_helper.dart';
import '../../../models/location.dart';
import '../../../services/login_service.dart';

class SignUpCompany extends StatefulWidget {
  const SignUpCompany({super.key});

  @override
  State<SignUpCompany> createState() => _SignUpCompanyState();
}

// const List<String> list = <String>[
//   'Sinh viên',
//   'Giảng viên',
//   'Giáo vụ',
//   'Nhân viên'
// ];

class _SignUpCompanyState extends State<SignUpCompany> {
  @override
  final TextEditingController nameCompanyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController benefitController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController addressCompanyController =
      TextEditingController();
  final TextEditingController applicationMethodController =
      TextEditingController();
  final TextEditingController positionDetailController =
      TextEditingController();
  // String dropdownValue = list.first;
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

  Future<void> loadJsonData() async {
    final String jsonData = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> data = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        title: Text(
          'Đăng ký tài khoản công ty',
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
                TextFormReceipt(
                  controller: emailController,
                  lableText: 'Email đăng nhập',
                  icon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  obcureText: true,
                  controller: passwordController,
                  lableText: 'Mật khẩu',
                  icon: const Icon(Icons.password_outlined),
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  controller: nameCompanyController,
                  lableText: 'Tên công ty',
                  icon: Icon(Icons.abc_outlined),
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  controller: addressController,
                  lableText: 'Công ty thuộc tỉnh thành',
                  icon: const Icon(Icons.location_city_outlined),
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  controller: positionController,
                  lableText: 'Vị trí hoặc công nghệ tuyển dụng chính',
                  icon: Icon(Icons.abc_outlined),
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  controller: salaryController,
                  lableText: 'Mức lương (Thỏa thuận thì điền 0)',
                  icon: Icon(Icons.abc_outlined),
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  controller: positionDetailController,
                  lableText: 'Vị trí tuyển dụng chi tiết',
                  maxline: 8,
                  icon: null,
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  controller: benefitController,
                  lableText: 'Quyền lợi của sinh viên',
                  maxline: 10,
                  icon: null,
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  controller: durationController,
                  lableText: 'Thời gian thực tập',
                  icon: null,
                  maxline: 10,
                ),
                const SizedBox(height: 10),
                TextFormReceipt(
                  controller: addressCompanyController,
                  lableText: 'Địa chỉ làm việc của công ty',
                  maxline: 10,
                  icon: Icon(Icons.abc_outlined),
                ),
                // const SizedBox(height: 10),
                // TextFormReceipt(
                //   controller: applicationMethodController,
                //   lableText: 'Cách thức ứng tuyển',
                //   icon: const Icon(Icons.abc_outlined),
                //   maxline: 3,
                // ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Loading().isShowLoading();
                      await LoginService().signUpAccount(
                        emailController.text,
                        passwordController.text,
                      );
                      final crurrenUser = FirebaseAuth.instance.currentUser;
                      CompanyDetail companyDetail = CompanyDetail(
                        address: addressCompanyController.text,
                        internshipDuration: durationController.text,
                        applicationMethod: "",
                        benefits: benefitController.text,
                        internshipPosition: positionDetailController.text,
                      );
                      CompanyIntern company = CompanyIntern(
                        '',
                        '',
                        nameCompanyController.text,
                        positionController.text,
                        double.parse(salaryController.text),
                        addressController.text,
                        companyDetail,
                        crurrenUser!.uid,
                        'Chờ duyệt',
                      );
                      Get.back();
                      FirebaseFirestore.instance
                          .collection('waitingReview')
                          .add(
                            company.toMap(),
                          )
                          .then((documentId) async {
                        String id = documentId.id;
                        UserModel userModel = UserModel(
                          idCompany: id,
                          uid: crurrenUser.uid,
                          email: crurrenUser.email,
                          type: 'Nhân viên',
                        );
                        await LoginService().postInfoToFireStore(userModel);
                        documentId.update(
                          {
                            'id': id,
                          },
                        );
                      });
                      // Get.back();
                      EasyLoading.showSuccess(
                          'Đăng ký thành công !\n Vui lòng chờ được phê duyệt');
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

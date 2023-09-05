// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:trungtamgiasu/constants/color.dart';
// // import 'package:trungtamgiasu/constants/loading.dart';
// // import 'package:trungtamgiasu/controllers/route_manager.dart';
// // import 'package:trungtamgiasu/models/user/user_model.dart';
// // import 'package:trungtamgiasu/views/widgets/custom_text_form_field.dart';

// // import '../../../constants/style.dart';
// // import '../../../constants/ui_helper.dart';
// // import '../../../services/login_service.dart';

// // class SignUpScreen extends StatefulWidget {
// //   const SignUpScreen({super.key});

// //   @override
// //   State<SignUpScreen> createState() => _SignUpScreenState();
// // }

// // class _SignUpScreenState extends State<SignUpScreen> {
// //   @override
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController addressController = TextEditingController();
// //   final TextEditingController emailController = TextEditingController();
// //   // UserModel userModel = Get.arguments;
// //   @override
// //   void initState() {
// //     // if (userModel.phoneNumber != null) {
// //     //   phoneController.text = userModel.phoneNumber.toString();
// //     //   nameController.text = "";
// //     //   emailController.text = "";
// //     //   addressController.text = "";
// //     // }
// //     // if (userModel.phoneNumber == null) {
// //     //   phoneController.text = "";
// //     //   nameController.text = userModel.userName.toString();
// //     //   emailController.text = userModel.email.toString();
// //     //   addressController.text = "";
// //     // }

// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: background,
// //       appBar: AppBar(
// //         backgroundColor: background,
// //         automaticallyImplyLeading: false,
// //         title: Text(
// //           'Cập nhật thông tin',
// //           style: Style.hometitleStyle,
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Form(
// //           child: Column(
// //             children: [
// //               CustomTextFormField(
// //                 controller: nameController,
// //                 hintText: 'Nhập tên',
// //                 iconData: Icons.abc_outlined,
// //               ),
// //               const SizedBox(height: 10),
// //               CustomTextFormField(
// //                 controller: emailController,
// //                 hintText: 'Nhập email',
// //                 iconData: Icons.email_outlined,
// //               ),
// //               const SizedBox(height: 10),
// //               CustomTextFormField(
// //                 controller: phoneController,
// //                 hintText: 'Nhập số điện thoại',
// //                 iconData: Icons.phone_android_outlined,
// //               ),
// //               const SizedBox(height: 10),
// //               CustomTextFormField(
// //                 controller: addressController,
// //                 hintText: 'Nhập địa chỉ',
// //                 iconData: Icons.location_city_outlined,
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   User? auth = FirebaseAuth.instance.currentUser;
// //                   try {
// //                     Loading().isShowLoading();
// //                     UserModel userModel = UserModel(
// //                         uid: auth?.uid,
// //                         userName: nameController.text,
// //                         email: emailController.text,
// //                         phoneNumber: phoneController.text,
// //                         address: addressController.text);
// //                     await auth?.updateDisplayName(nameController.text);
// //                     await auth?.updateEmail(emailController.text);
// //                     await LoginService().postInfoToFireStore(userModel);
// //                     Get.offAllNamed(RouteManager.layoutScreen);
// //                   } catch (e) {
// //                     UIHelper.showFlushbar(message: e.toString());
// //                   } finally {
// //                     await Loading().isOffShowLoading();
// //                   }
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   minimumSize: Size(Get.width, 54),
// //                   elevation: 0.0,
// //                   backgroundColor: dashTeal,
// //                   side: const BorderSide(
// //                     color: Colors.grey,
// //                     width: 1.0,
// //                   ),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10.0),
// //                   ),
// //                 ),
// //                 child: Text(
// //                   'Cập nhật'.toUpperCase(),
// //                   // 'login'.tr.capitalize,
// //                   style: Style.titleStyle.copyWith(color: backgroundLite),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

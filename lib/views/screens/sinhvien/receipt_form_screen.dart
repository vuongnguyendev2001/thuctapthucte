import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';

class ReceiptFormScreen extends StatefulWidget {
  const ReceiptFormScreen({super.key});

  @override
  State<ReceiptFormScreen> createState() => _ReceiptFormScreenState();
}

class _ReceiptFormScreenState extends State<ReceiptFormScreen> {
  bool? _isSelected1 = false;
  bool? _isSelected2 = false;
  final TextEditingController _nameCompanyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneNumberCompanyController =
      TextEditingController();
  final TextEditingController _userNameCanBoController =
      TextEditingController();
  final TextEditingController _emailCanBoController = TextEditingController();
  final TextEditingController _userNameStudentController =
      TextEditingController();
  final TextEditingController _phoneNumberCanBoStudentController =
      TextEditingController();
  final TextEditingController _mssvController = TextEditingController();
  final TextEditingController _idClassController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _workContentController = TextEditingController();
  CompanyIntern? company;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RegisterViewerArguments? arguments =
        Get.arguments as RegisterViewerArguments?;
    _nameCompanyController.text = arguments!.companyIntern.name;
    _locationController.text = arguments.companyIntern.companyDetail.address;
    _userNameStudentController.text = arguments.userModel.userName!;
    _idClassController.text = arguments.userModel.idClass!;
    _majorController.text = arguments.userModel.major!;
    _mssvController.text = arguments.userModel.MSSV!;
    getUserForCompany(arguments.companyIntern);
  }

  Future<List<CompanyIntern>> getCompanies() async {
    QuerySnapshot companiesSnapshot =
        await FirebaseFirestore.instance.collection('companies').get();
    List<CompanyIntern> companies = [];
    companiesSnapshot.docs.forEach((orderDoc) {
      CompanyIntern company =
          CompanyIntern.fromMap(orderDoc.data() as Map<String, dynamic>);
      companies.add(company);
    });
    return companies;
  }

  Future<void> getUserForCompany(CompanyIntern company) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(company.idUserCanBo)
        .get();
    if (userSnapshot.exists) {
      try {
        UserModel user =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        setState(() {
          _userNameCanBoController.text = user.userName!;
          _phoneNumberCanBoStudentController.text = user.phoneNumberCanBo!;
          _phoneNumberCompanyController.text = user.phoneNumberCompany!;
        });
      } catch (e) {
        print(e);
      }
    } else {
      print('null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Phiếu tiếp nhận sinh viên'.toUpperCase(),
            style: Style.homeStyle),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextFormReceipt(
                      controller: _nameCompanyController,
                      lableText: 'Tên cơ quan',
                      icon: const Icon(Icons.abc_outlined),
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      controller: _locationController,
                      lableText: 'Địa chỉ cơ quan',
                      icon: const Icon(Icons.location_city_outlined),
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      controller: _phoneNumberCompanyController,
                      lableText: 'Số điện thoại cơ quan',
                      icon: const Icon(Icons.phone_iphone_outlined),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormReceipt(
                            controller: _userNameCanBoController,
                            lableText: 'Họ và tên cán bộ',
                            icon: const Icon(Icons.abc_outlined),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormReceipt(
                            controller: _phoneNumberCanBoStudentController,
                            lableText: 'Số điện thoại cán bộ',
                            icon: const Icon(Icons.phone_iphone_outlined),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Điều kiện cho sinh viên thực tập bao gồm: ',
                      style: Style.subtitleStyle,
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Phòng làm việc'),
                      activeColor: primaryColor,
                      value: _isSelected1,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isSelected1 = newValue;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Máy tính'),
                      activeColor: primaryColor,
                      value: _isSelected2,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isSelected2 = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Đồng ý nhận sinh viên:',
                      style: Style.subtitleStyle,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormReceipt(
                            controller: _userNameStudentController,
                            lableText: 'Họ và tên SV',
                            icon: null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormReceipt(
                            controller: _mssvController,
                            lableText: 'Mã số SV',
                            icon: null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormReceipt(
                            controller: _idClassController,
                            lableText: 'Mã lớp',
                            icon: null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormReceipt(
                            controller: _majorController,
                            lableText: 'Ngành học',
                            icon: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: Get.width,
              height: 55,
              color: greyFontColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 50,
                    width: Get.width * 0.7,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {},
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: backgroundLite,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Đăng ký thực tập',
                                  // 'login'.tr.capitalize,
                                  style: Style.titleStyle.copyWith(
                                      color: backgroundLite, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                      radius: 20,
                      backgroundColor: whiteColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFormReceipt extends StatelessWidget {
  String? lableText;
  TextEditingController? controller;
  Icon? icon;
  TextFormReceipt(
      {super.key,
      required this.lableText,
      required this.controller,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Vui lòng nhập số điện thoại';
        }
        // if (!(value?.trim().isPhoneNumber ?? false)) {
        //   return 'Số điện thoại không hợp lệ';
        // }
        return null;
      },
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: icon,
        prefixIconColor: primaryColor,
        contentPadding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal:
                8.0), // Điều này sẽ giúp điều chỉnh kích thước của TextFormField.
        labelText: lableText,
        labelStyle: const TextStyle(color: blackColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
                color: primaryColor) // Màu của viền khi trường được chọn
            ),
      ),
    );
  }
}

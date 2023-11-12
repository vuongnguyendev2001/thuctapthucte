import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/mentor/receipt_form_screen.dart';

class InformationCompany extends StatefulWidget {
  const InformationCompany({super.key});

  @override
  State<InformationCompany> createState() => _InformationCompanyState();
}

class _InformationCompanyState extends State<InformationCompany> {
  CompanyIntern? companyIntern;
  String? idDoc, idCanBo, logo;
  final TextEditingController nameCompany = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController salary = TextEditingController();
  final TextEditingController benefits = TextEditingController();
  final TextEditingController internshipPosition = TextEditingController();
  final TextEditingController internshipDuration = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController applicationMethod = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    companyIntern = Get.arguments as CompanyIntern;
    nameCompany.text = companyIntern!.name!;
    position.text = companyIntern!.position!;
    location.text = companyIntern!.location!;
    salary.text = companyIntern!.salary.toString();
    benefits.text = companyIntern!.companyDetail!.benefits;
    internshipPosition.text = companyIntern!.companyDetail!.internshipPosition;
    internshipDuration.text = companyIntern!.companyDetail!.internshipDuration;
    address.text = companyIntern!.companyDetail!.address;
    applicationMethod.text = companyIntern!.companyDetail!.applicationMethod;
    idDoc = companyIntern!.id;
    idCanBo = companyIntern!.idUserCanBo;
    logo = companyIntern!.logo;
    print(companyIntern!.id);
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        title: Text(
          'Thông tin công ty',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormReceipt(
                      lableText: 'Tên công ty',
                      controller: nameCompany,
                      icon: null,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      lableText: 'Vị trí tuyển dụng',
                      controller: position,
                      icon: null,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      lableText: 'Mức lương',
                      controller: salary,
                      icon: null,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      lableText: 'Địa chỉ công ty',
                      controller: location,
                      icon: null,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      lableText: 'Quyền lợi',
                      controller: benefits,
                      icon: null,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      lableText: 'Vị trí cụ thể',
                      controller: internshipPosition,
                      icon: null,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      lableText: 'Thời gian thực tập',
                      controller: internshipDuration,
                      icon: null,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      lableText: 'Địa chỉ cụ thể',
                      controller: address,
                      icon: null,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      lableText: 'Cách ứng tuyển',
                      controller: applicationMethod,
                      icon: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              CompanyDetail companyDetail = CompanyDetail(
                internshipPosition: internshipPosition.text,
                internshipDuration: internshipDuration.text,
                benefits: benefits.text,
                applicationMethod: applicationMethod.text,
                address: address.text,
              );
              CompanyIntern companyIntern = CompanyIntern(
                idDoc,
                logo!,
                nameCompany.text,
                position.text,
                double.parse(salary.text),
                location.text,
                companyDetail,
                idCanBo,
                ''
              );
              FirebaseFirestore.instance
                  .collection('companies')
                  .doc(idDoc!)
                  .update(
                    companyIntern.toMap(),
                  )
                  .then((_) {
                EasyLoading.showSuccess('Cập nhật thành công');
              }).catchError((error) {
                print('Lỗi khi cập nhật ID của tài liệu: $error');
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: Get.width,
              height: 45,
              color: primaryColor,
              child: Text(
                'Cập nhật thông tin',
                style: Style.homeTitleStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}

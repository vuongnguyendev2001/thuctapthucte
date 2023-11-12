import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/receipt_form.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/mentor/receipt_form_screen.dart';

class ReadDetailReceiptFormScreen extends StatefulWidget {
  const ReadDetailReceiptFormScreen({super.key});

  @override
  State<ReadDetailReceiptFormScreen> createState() =>
      _ReadDetailReceiptFormScreenState();
}

class _ReadDetailReceiptFormScreenState
    extends State<ReadDetailReceiptFormScreen> {
  String idDocument = ''; // Declare idDocument
  Stream<DocumentSnapshot>? _receiptFormFirestore;

  @override
  void initState() {
    super.initState();
    idDocument = Get.arguments as String; // Initialize idDocument

    _receiptFormFirestore = FirebaseFirestore.instance
        .collection('ReceiptForm')
        .doc(idDocument)
        .snapshots();
    // Now _receiptFormFirestore is properly initialized.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Phiếu tiếp nhận sinh viên'.toUpperCase(),
            style: Style.homeStyle),
        // centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _receiptFormFirestore,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              loggedInUser.uid == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          final Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          ReceiptForm receiptFormList = ReceiptForm.fromMap(data);
          TextEditingController nameComapny =
              TextEditingController(text: receiptFormList.companyIntern!.name);
          TextEditingController _locationController = TextEditingController(
              text: receiptFormList.companyIntern!.location);
          TextEditingController _phoneNumberCompanyController =
              TextEditingController(
                  text: receiptFormList.userCanBo!.phoneNumberCompany);
          TextEditingController _userNameCanBoController =
              TextEditingController(text: receiptFormList.userCanBo!.userName);
          TextEditingController _phoneNumberCanBoStudentController =
              TextEditingController(
                  text: receiptFormList.userCanBo!.phoneNumberCanBo);
          TextEditingController _userNameStudentController =
              TextEditingController(
                  text: receiptFormList.userStudent!.userName);
          TextEditingController _mssvController =
              TextEditingController(text: receiptFormList.userStudent!.MSSV);
          TextEditingController _idClassController =
              TextEditingController(text: receiptFormList.userStudent!.idClass);
          TextEditingController _majorController =
              TextEditingController(text: receiptFormList.userStudent!.major);
          TextEditingController _hourperdayController =
              TextEditingController(text: receiptFormList.hourPerDay);
          TextEditingController _dayperweekController =
              TextEditingController(text: receiptFormList.dayPerWeek);
          TextEditingController _workContentController =
              TextEditingController(text: receiptFormList.workContent);
          TextEditingController _phone = TextEditingController(
              text: receiptFormList.userCanBo!.phoneNumberCompany);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextFormReceipt(
                      isReadOnly: true,
                      controller: nameComapny,
                      lableText: 'Tên cơ quan',
                      icon: const Icon(Icons.abc_outlined),
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      isReadOnly: true,
                      controller: _locationController,
                      lableText: 'Địa chỉ cơ quan',
                      icon: const Icon(Icons.location_city_outlined),
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      isReadOnly: true,
                      controller: _phoneNumberCompanyController,
                      lableText: 'Số điện thoại cơ quan',
                      icon: const Icon(Icons.phone_iphone_outlined),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormReceipt(
                            isReadOnly: true,
                            controller: _userNameCanBoController,
                            lableText: 'Họ và tên cán bộ',
                            icon: const Icon(Icons.abc_outlined),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormReceipt(
                            isReadOnly: true,
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
                      value: receiptFormList.isWorkRoomSelected1,
                      onChanged: (bool? newValue) {},
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Thiết bị (máy tính, màn hình rời,..)'),
                      activeColor: primaryColor,
                      value: receiptFormList.isComputerSelected2,
                      onChanged: (bool? newValue) {},
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Trợ cấp thực tập'),
                      activeColor: primaryColor,
                      value: receiptFormList.isSalarySelected2,
                      onChanged: (bool? newValue) {},
                    ),
                    CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Thực tập online'),
                      activeColor: primaryColor,
                      value: receiptFormList.isWorkOnlineSelected,
                      onChanged: (bool? newValue) {},
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
                            isReadOnly: true,
                            controller: _userNameStudentController,
                            lableText: 'Họ và tên SV',
                            icon: null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormReceipt(
                            isReadOnly: true,
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
                            isReadOnly: true,
                            controller: _idClassController,
                            lableText: 'Mã lớp',
                            icon: null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormReceipt(
                            isReadOnly: true,
                            controller: _majorController,
                            lableText: 'Ngành học',
                            icon: null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Dự kiến số ngày sinh viên sẽ có mặt tại nơi thực tập, tối thiểu 24 giờ/ 1 tuần:',
                      style: Style.subtitleStyle,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormReceipt(
                            isReadOnly: true,
                            controller: _hourperdayController,
                            lableText: 'Số giờ/ngày',
                            icon: null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormReceipt(
                            isReadOnly: true,
                            controller: _dayperweekController,
                            lableText: 'Số ngày/tuần',
                            icon: null,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Nội dung công việc – bắt buộc phải có\nLưu ý: Công việc được thực hiện trong 8 tuần',
                      style: Style.subtitleStyle,
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      isReadOnly: true,
                      controller: _workContentController,
                      lableText: 'Nội dung công việc',
                      icon: null,
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Người lập: ${receiptFormList.userCanBo!.userName}",
                          ),
                          Text(
                            "Ngày lập: ${CurrencyFormatter().formattedDatebook(receiptFormList.timestamp)}",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

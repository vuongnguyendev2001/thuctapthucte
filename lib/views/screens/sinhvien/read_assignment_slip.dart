import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/receipt_form_screen.dart';

class ReadAssignmentSlip extends StatefulWidget {
  const ReadAssignmentSlip({super.key});

  @override
  State<ReadAssignmentSlip> createState() => _ReadAssignmentSlipState();
}

class _ReadAssignmentSlipState extends State<ReadAssignmentSlip> {
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  UserModel loggedInUser = UserModel();
  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  final Stream<QuerySnapshot> _assignmentSlipFormFirestore =
      FirebaseFirestore.instance.collection('AssignmentSlip').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Phiếu giao việc sinh viên'.toUpperCase(),
          style: Style.homeStyle,
        ),
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
          stream: _assignmentSlipFormFirestore,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            List<AssignmentSlip> assignmentSlipFormList = [];
            for (QueryDocumentSnapshot document in snapshot.data!.docs) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              AssignmentSlip assignmentSlipForm = AssignmentSlip.fromMap(data);
              assignmentSlipFormList.add(assignmentSlipForm);
            }
            return ListView.builder(
                itemCount: assignmentSlipFormList.length,
                itemBuilder: (context, index) {
                  if (assignmentSlipFormList[index].mssvController.text ==
                      loggedInUser.MSSV) {
                    return SizedBox(
                      width: Get.width,
                      height: Get.height,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 60),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormReceipt(
                                      isReadOnly: true,
                                      controller: assignmentSlipFormList[index]
                                          .nameStudentController,
                                      lableText: 'Họ và tên SV',
                                      icon: null,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: TextFormReceipt(
                                      isReadOnly: true,
                                      controller: assignmentSlipFormList[index]
                                          .mssvController,
                                      lableText: 'Mã số SV',
                                      icon: null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextFormReceipt(
                                isReadOnly: true,
                                controller: assignmentSlipFormList[index]
                                    .nameCompanyController,
                                lableText: 'Tên cơ quan',
                                icon: const Icon(Icons.abc_outlined),
                              ),
                              const SizedBox(height: 15),
                              TextFormReceipt(
                                isReadOnly: true,
                                controller: assignmentSlipFormList[index]
                                    .nameCanBoController,
                                lableText: 'Họ và tên cán bộ',
                                icon: const Icon(Icons.abc_outlined),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  text: 'Thời gian thực tập: ',
                                  style: Style.subtitleStyle,
                                  children: const <TextSpan>[
                                    TextSpan(text: ' từ ngày '),
                                    TextSpan(
                                        text: '15/5/2023',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: ' đến'),
                                    TextSpan(
                                        text: ' 8/7/2023',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: assignmentSlipFormList[index]
                                    .workContentControllers!
                                    .length,
                                itemBuilder: (context, indexWordContent) {
                                  return Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                            width: Get.width,
                                            color: whiteColor,
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: TextFormReceipt(
                                                        isReadOnly: true,
                                                        controller: assignmentSlipFormList[
                                                                index]
                                                            .workContentControllers![
                                                                indexWordContent]
                                                            .weekNumberController,
                                                        lableText: 'Tuần',
                                                        icon: null,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Expanded(
                                                      flex: 4,
                                                      child: TextFormReceipt(
                                                        isReadOnly: true,
                                                        controller: assignmentSlipFormList[
                                                                index]
                                                            .workContentControllers![
                                                                indexWordContent]
                                                            .sessionNumberController,
                                                        lableText:
                                                            'Số buổi (VD: 6h/buổi, 6b/tuần)',
                                                        icon: null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                TextFormReceipt(
                                                  isReadOnly: true,
                                                  controller: assignmentSlipFormList[
                                                          index]
                                                      .workContentControllers![
                                                          indexWordContent]
                                                      .workContentDetailController,
                                                  lableText:
                                                      'Nội dung công việc được giao',
                                                  icon: const Icon(
                                                      Icons.abc_outlined),
                                                ),
                                              ],
                                            )),
                                      ),
                                      const SizedBox(height: 10)
                                    ],
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Ngày lập: ${CurrencyFormatter().formattedDatebook(assignmentSlipFormList[index].dateTime)}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                });
          }),
    );
  }
}

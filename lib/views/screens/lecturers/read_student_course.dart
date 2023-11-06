import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/receipt_form.dart';
import 'package:trungtamgiasu/models/registration_model.dart';
import 'package:trungtamgiasu/models/result_evaluation.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

class ReadStudentCourse extends StatefulWidget {
  const ReadStudentCourse({super.key});

  @override
  State<ReadStudentCourse> createState() => _ReadStudentCourseState();
}

class _ReadStudentCourseState extends State<ReadStudentCourse> {
  bool showSearch = false;
  String _searchStudent = "";
  final Stream<QuerySnapshot> _readStudentCourseFirestore = FirebaseFirestore
      .instance
      .collection('DangKyHocPhan')
      .orderBy('user.MSSV')
      .snapshots();
  @override
  void initState() {
    super.initState();
    fetchData();
    // count = getAllDKHP(loggedInUser.uid!);
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  CollectionReference DKHPCollection =
      FirebaseFirestore.instance.collection('DangKyHocPhan');
  Future<bool?> getAllDKHP(String userID) async {
    int count = 0;
    QuerySnapshot querySnapshot = await DKHPCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DangKyHocPhan dangKyHocPhan = DangKyHocPhan.fromMap(data);
        if (dangKyHocPhan.idGiangVien == userID) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> JdCompany(BuildContext context, CompanyIntern companies) {
    return showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  color: background,
                  height: Get.height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const CircleAvatar(
                            child: Icon(Icons.arrow_back_ios_outlined),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(10),
                          color: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                companies.position!,
                                style: Style.titleStyle,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    child: Image.network(
                                      companies.logo!,
                                      height: 55,
                                      width: 55,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    companies.name!.toUpperCase(),
                                    style: Style.titlegreyStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(10),
                          color: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vị trí thực tập: ',
                                  style: Style.titleStyle),
                              Text(
                                companies.companyDetail!.internshipPosition,
                                style: Style.subtitleStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(10),
                          color: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Thời gian thực tập: ',
                                  style: Style.titleStyle),
                              Text(
                                companies.companyDetail!.internshipDuration,
                                style: Style.subtitleStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(10),
                          color: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quyền lợi: ', style: Style.titleStyle),
                              Text(
                                companies.companyDetail!.benefits,
                                style: Style.subtitleStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(10),
                          color: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Địa điểm thực tập: ',
                                  style: Style.titleStyle),
                              Text(
                                companies.companyDetail!.address,
                                style: Style.subtitleStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(10),
                          color: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nhận hồ sơ: ', style: Style.titleStyle),
                              Text(
                                companies.companyDetail!.applicationMethod,
                                style: Style.subtitleStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  CollectionReference internshipApplicationsCollection =
      FirebaseFirestore.instance.collection('registrations');
  Future<CompanyIntern?> getAllApplications(String userID) async {
    QuerySnapshot querySnapshot = await internshipApplicationsCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        RegistrationModel internshipApplication =
            RegistrationModel.fromMap(data);
        if (internshipApplication.user.uid == userID &&
            internshipApplication.status == "Đã duyệt") {
          return internshipApplication.Company;
        }
      }
    }
    return null;
  }

  CollectionReference receptFormCollection =
      FirebaseFirestore.instance.collection('ReceiptForm');
  Future<String?> getAllReceptForm(String userID) async {
    QuerySnapshot querySnapshot = await receptFormCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        ReceiptForm receiptForm = ReceiptForm.fromMap(data);
        if (receiptForm.userStudent!.uid == userID) {
          return receiptForm.id;
        }
      }
    }
    return 'null';
  }

  CollectionReference assignmentSlipCollection =
      FirebaseFirestore.instance.collection('AssignmentSlip');
  Future<String?> getAllAssignmentSlip(String mSSV) async {
    QuerySnapshot querySnapshot = await assignmentSlipCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        AssignmentSlip assignmentSlip = AssignmentSlip.fromMap(data);
        if (assignmentSlip.mssvController.text == mSSV) {
          return assignmentSlip.id;
        }
      }
    }
    return 'null';
  }

  CollectionReference readValuationCollection =
      FirebaseFirestore.instance.collection('ResultsEvaluation');
  Future<String?> getAllResultsEvaluation(String userID) async {
    QuerySnapshot querySnapshot = await readValuationCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        ResultEvaluation resultEvaluation = ResultEvaluation.fromMap(data);
        if (resultEvaluation.userStudent!.uid == userID) {
          return resultEvaluation.id;
        }
      }
    }
    return 'null';
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Danh sách sinh viên',
            style: Style.homeTitleStyle,
          ),
          backgroundColor: primaryColor,
          actions: [
            InkWell(
              onTap: () async {
                if (showSearch == false) {
                  setState(() {
                    showSearch = true;
                  });
                } else {
                  setState(() {
                    showSearch = false;
                  });
                }
              },
              child: CircleAvatar(
                backgroundColor: whiteColor,
                radius: 17,
                child: const Icon(Icons.search_outlined),
              ),
            ),
            const SizedBox(width: 5),
          ],
          bottom: showSearch == true
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(
                      48.0), // Đặt chiều cao của phần bottom
                  child: Container(
                    color: whiteColor,
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        hintText: 'Mã số sinh viên hoặc tên sinh viên',
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _searchStudent = value;
                        setState(() {});
                      },
                    ),
                  ),
                )
              : null),
      body: StreamBuilder<QuerySnapshot>(
        stream: _readStudentCourseFirestore,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          List<DangKyHocPhan> dkhpList = [];
          for (QueryDocumentSnapshot document in snapshot.data!.docs) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            DangKyHocPhan dangKyHocPhan = DangKyHocPhan.fromMap(data);
            dkhpList.add(dangKyHocPhan);
          }
          List<DangKyHocPhan> dkhpFromMSSVList = [];
          for (DangKyHocPhan dkhp in dkhpList) {
            if (dkhp.idGiangVien == loggedInUser.uid) {
              if (dkhp.user.MSSV!
                      .toLowerCase()
                      .contains(_searchStudent.toLowerCase()) ||
                  dkhp.user.userName!
                      .toLowerCase()
                      .contains(_searchStudent.toLowerCase())) {
                dkhpFromMSSVList.add(dkhp);
              }
            }
          }
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  border: TableBorder.all(),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(30),
                    1: FixedColumnWidth(170),
                    2: FlexColumnWidth()
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Center(
                          child: Text(
                            'STT',
                            style: Style.titleStyle,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Thông tin',
                            style: Style.titleStyle,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Tiến độ',
                            style: Style.titleStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dkhpFromMSSVList.length,
                    itemBuilder: (context, index) {
                      if (dkhpList[index].idGiangVien == loggedInUser.uid) {
                        return Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(30),
                            1: FixedColumnWidth(170),
                            2: FlexColumnWidth()
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'MS: ${dkhpFromMSSVList[index].user.MSSV}',
                                        style: Style.subtitleStyle,
                                      ),
                                      Text(
                                        'Tên: ${dkhpFromMSSVList[index].user.userName}',
                                        style: Style.subtitleStyle,
                                      ),
                                      Text(
                                        'SĐT: ${dkhpFromMSSVList[index].user.phoneNumber}',
                                        style: Style.subtitleStyle,
                                      ),
                                      Text(
                                        'Lớp: ${dkhpFromMSSVList[index].user.idClass}',
                                        style: Style.subtitleStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Checkbox(
                                                  checkColor: primaryColor,
                                                  fillColor:
                                                      const MaterialStatePropertyAll(
                                                    Colors.white70,
                                                  ),
                                                  value: dkhpFromMSSVList[index]
                                                      .locationIntern,
                                                  onChanged: null,
                                                ),
                                              ),
                                              Text(
                                                'Nơi thực tập',
                                                style: Style.subtitleStyle,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              CompanyIntern? companyIntern =
                                                  await getAllApplications(
                                                      dkhpFromMSSVList[index]
                                                          .user
                                                          .uid!);
                                              JdCompany(
                                                  context, companyIntern!);
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.visibility_rounded,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Checkbox(
                                                    checkColor: primaryColor,
                                                    fillColor:
                                                        const MaterialStatePropertyAll(
                                                      Colors.white70,
                                                    ),
                                                    value:
                                                        dkhpFromMSSVList[index]
                                                            .receiptForm,
                                                    onChanged: null),
                                              ),
                                              Text(
                                                'Phiếu tiếp nhận',
                                                style: Style.subtitleStyle,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              String? idReceptForm =
                                                  await getAllReceptForm(
                                                      dkhpFromMSSVList[index]
                                                          .user
                                                          .uid!);
                                              Get.toNamed(
                                                  RouteManager
                                                      .readDetailReceiptForm,
                                                  arguments: idReceptForm);
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.visibility_rounded,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Checkbox(
                                                    checkColor: primaryColor,
                                                    fillColor:
                                                        const MaterialStatePropertyAll(
                                                      Colors.white70,
                                                    ),
                                                    value:
                                                        dkhpFromMSSVList[index]
                                                            .assignmentSlipForm,
                                                    onChanged: null),
                                              ),
                                              Text(
                                                'Phiếu giao việc',
                                                style: Style.subtitleStyle,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              String? idAssignmentSlip =
                                                  await getAllAssignmentSlip(
                                                      dkhpFromMSSVList[index]
                                                          .user
                                                          .MSSV!);
                                              Get.toNamed(
                                                RouteManager
                                                    .readDetailAssignmentSlip,
                                                arguments: idAssignmentSlip,
                                              );
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.visibility_rounded,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Checkbox(
                                                    checkColor: primaryColor,
                                                    fillColor:
                                                        const MaterialStatePropertyAll(
                                                      Colors.white70,
                                                    ),
                                                    value:
                                                        dkhpFromMSSVList[index]
                                                            .evaluation,
                                                    onChanged: null),
                                              ),
                                              Text(
                                                'Cán bộ đánh giá',
                                                style: Style.subtitleStyle,
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              String? idResultValuation =
                                                  await getAllResultsEvaluation(
                                                dkhpFromMSSVList[index]
                                                    .user
                                                    .uid!,
                                              );
                                              Get.toNamed(
                                                RouteManager
                                                    .lectureReadResultsEvaluation,
                                                arguments: idResultValuation,
                                              );
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.visibility_rounded,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Checkbox(
                                                    checkColor: primaryColor,
                                                    fillColor:
                                                        const MaterialStatePropertyAll(
                                                      Colors.white70,
                                                    ),
                                                    value:
                                                        dkhpFromMSSVList[index]
                                                            .isSubmitReport,
                                                    onChanged: null),
                                              ),
                                              Text(
                                                'Nộp báo cáo',
                                                style: Style.subtitleStyle,
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              PdfViewerArguments arguments =
                                                  PdfViewerArguments(
                                                dkhpFromMSSVList[index]
                                                    .submitReport!
                                                    .urlReport,
                                                dkhpFromMSSVList[index]
                                                    .submitReport!
                                                    .titleReport,
                                              );
                                              Get.toNamed(
                                                RouteManager.pdfViewer,
                                                arguments: arguments,
                                              );
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.visibility_rounded,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

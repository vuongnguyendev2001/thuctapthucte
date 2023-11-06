import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/constants/ui_helper.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/course_register.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/result_evaluation.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

class LecturersEvaluation extends StatefulWidget {
  const LecturersEvaluation({super.key});

  @override
  State<LecturersEvaluation> createState() => _LecturersEvaluationState();
}

class _LecturersEvaluationState extends State<LecturersEvaluation> {
  String? selectedSemester;
  String? selectedAcademicYear;
  final Stream<QuerySnapshot> _readStudentCourseFirestore = FirebaseFirestore
      .instance
      .collection('DangKyHocPhan')
      .orderBy('user.MSSV')
      .snapshots();
  final Stream<QuerySnapshot> _SemesterCollection =
      FirebaseFirestore.instance.collection('HocKi').snapshots();
  @override
  void initState() {
    super.initState();
    fetchData();
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

  CollectionReference canBoEvaluation =
      FirebaseFirestore.instance.collection('ResultsEvaluation');
  Future<String?> getAllcanBoEvaluation(String IDStudent) async {
    QuerySnapshot querySnapshot = await canBoEvaluation.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        ResultEvaluation resultEvaluation = ResultEvaluation.fromMap(data);
        if (resultEvaluation.userStudent!.uid == IDStudent) {
          return resultEvaluation.sumScore;
        }
      }
    }
    return 'null';
  }

  bool showSearch = false;
  String _searchStudent = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Đánh giá kết quả',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
        actions: [
          GestureDetector(
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _SemesterCollection,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else if (snapshot.data!.docs.isEmpty) {
            return const Text('Không có dữ liệu.');
          } else {
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            List<CourseRegistration> courseRegistrations = [];
            for (QueryDocumentSnapshot doc in documents) {
              String idDocument = doc.id;
              Map<String, dynamic> jsonData =
                  doc.data() as Map<String, dynamic>;
              CourseRegistration courseRegistration =
                  CourseRegistration.fromMap(jsonData);
              courseRegistration.id = idDocument;
              courseRegistrations.add(courseRegistration);
            }
            List<String> uniqueSemesters = courseRegistrations
                .map((courseRegistration) => courseRegistration.semester)
                .toSet()
                .toList();

            List<String> uniqueAcademicYears = courseRegistrations
                .map((courseRegistration) => courseRegistration.academicYear)
                .toSet()
                .toList();
            selectedSemester ??= uniqueSemesters.isNotEmpty
                ? uniqueSemesters.first
                : null; // Đặt giá trị đầu tiên nếu không có giá trị đã chọn
            selectedAcademicYear ??= uniqueAcademicYears.isNotEmpty
                ? uniqueAcademicYears.first
                : null;
            return Column(
              children: [
                showSearch == true
                    ? Container(
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
                            hintText: 'Mã số sinh viên',
                            prefixIcon: Icon(
                              Icons.search,
                              color: primaryColor,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchStudent = value;
                            });
                          },
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Học kỳ: ',
                              style: Style.subtitleBlackGiaovuStyle,
                            ),
                            Container(
                              height: 25,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(),
                              ),
                              child: DropdownButton<String>(
                                underline: Container(),
                                value: selectedSemester,
                                onChanged: (newValue) {
                                  selectedSemester = newValue;
                                  setState(() {});
                                },
                                items: uniqueSemesters
                                    .map((semester) => DropdownMenuItem<String>(
                                          value: semester,
                                          child: Text(
                                            semester,
                                            style: Style.subtitleStyle,
                                          ),
                                        ))
                                    .toList(),
                                hint: const Text(''),
                              ),
                            ),
                            Text(
                              ' - Năm học: ',
                              style: Style.subtitleBlackGiaovuStyle,
                            ),
                            Container(
                              height: 25,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(),
                              ),
                              child: DropdownButton<String>(
                                underline: Container(),
                                value: selectedAcademicYear,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedAcademicYear = newValue;
                                  });
                                },
                                items: uniqueAcademicYears
                                    .map((academicYear) =>
                                        DropdownMenuItem<String>(
                                          value: academicYear,
                                          child: Text(
                                            academicYear,
                                            style: Style.subtitleStyle,
                                          ),
                                        ))
                                    .toList(),
                                hint: const Text(''),
                              ),
                            ),
                          ],
                        ),
                      ),
                StreamBuilder<QuerySnapshot>(
                  stream: _readStudentCourseFirestore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    for (QueryDocumentSnapshot document
                        in snapshot.data!.docs) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      DangKyHocPhan dangKyHocPhan = DangKyHocPhan.fromMap(data);
                      dkhpList.add(dangKyHocPhan);
                    }
                    List<DangKyHocPhan> dkhpFromMSSVList = [];
                    for (DangKyHocPhan dkhp in dkhpList) {
                      if (dkhp.idGiangVien == loggedInUser.uid) {
                        if (dkhp.user.MSSV!
                            .toLowerCase()
                            .contains(_searchStudent.toLowerCase())) {
                          dkhpFromMSSVList.add(dkhp);
                        }
                      }
                    }
                    return Column(
                      children: [
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            UIHelper.showCupertinoDialog(
                              title: 'Thông báo',
                              isShowClose: true,
                              message:
                                  'Khóa điểm sẽ không được chỉnh sửa !\n Bạn có đồng ý không?',
                              titleConfirm: 'Đồng ý',
                              titleClose: 'Đóng',
                              onComfirm: () {
                                for (DangKyHocPhan dkhp in dkhpFromMSSVList) {
                                  FirebaseFirestore.instance
                                      .collection('DangKyHocPhan')
                                      .doc(dkhp.idDKHP)
                                      .update({
                                    "lockScore": true,
                                  });
                                }
                                Get.back();
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              color: primaryColor,
                              width: Get.width * 0.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    color: whiteColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Khóa bảng điểm',
                                    style: Style.homesubtitleStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Table(
                            border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(30),
                              1: FixedColumnWidth(70),
                              2: FixedColumnWidth(135),
                              3: FixedColumnWidth(50),
                              4: FixedColumnWidth(50),
                              5: FlexColumnWidth()
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
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
                                      'MSSV',
                                      style: Style.titleStyle,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Họ & Tên',
                                      style: Style.titleStyle,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Điểm số',
                                      style: Style.titleStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Điểm chữ',
                                      textAlign: TextAlign.center,
                                      style: Style.titleStyle,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Chấm điểm',
                                      textAlign: TextAlign.center,
                                      style: Style.titleStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: courseRegistrations.length,
                          itemBuilder: (context, index) {
                            CourseRegistration courseRegistration =
                                courseRegistrations[index];
                            if (courseRegistration.semester ==
                                    selectedSemester &&
                                courseRegistration.academicYear ==
                                    selectedAcademicYear) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      // physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: dkhpFromMSSVList.length,
                                      itemBuilder: (context, indexFromMSSV) {
                                        // double totalWord;
                                        // if (dkhpFromMSSVList[index].lecturersEvaluation !=
                                        //     null) {
                                        //   totalWord = double.parse(dkhpFromMSSVList[index]
                                        //       .lecturersEvaluation!
                                        //       .total!);
                                        // }
                                        return Column(
                                          children: [
                                            const SizedBox(height: 8),
                                            Table(
                                              border: TableBorder.all(),
                                              columnWidths: const <int,
                                                  TableColumnWidth>{
                                                0: FixedColumnWidth(30),
                                                1: FixedColumnWidth(70),
                                                2: FixedColumnWidth(135),
                                                3: FixedColumnWidth(50),
                                                4: FixedColumnWidth(50),
                                                5: FlexColumnWidth()
                                              },
                                              defaultVerticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              children: <TableRow>[
                                                TableRow(
                                                  children: <Widget>[
                                                    Center(
                                                      child: Text(
                                                        '${indexFromMSSV + 1}',
                                                        style:
                                                            Style.subtitleStyle,
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        '${dkhpFromMSSVList[indexFromMSSV].user.MSSV}',
                                                        style:
                                                            Style.subtitleStyle,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Text(
                                                        '${dkhpFromMSSVList[indexFromMSSV].user.userName}',
                                                        style:
                                                            Style.subtitleStyle,
                                                      ),
                                                    ),
                                                    dkhpFromMSSVList[
                                                                    indexFromMSSV]
                                                                .lecturersEvaluation !=
                                                            null
                                                        ? Center(
                                                            child: Text(
                                                              '${dkhpFromMSSVList[indexFromMSSV].lecturersEvaluation!.total}',
                                                              style: Style
                                                                  .subtitleStyle,
                                                            ),
                                                          )
                                                        : Center(
                                                            child: Text(
                                                              '-',
                                                              style: Style
                                                                  .subtitleStyle,
                                                            ),
                                                          ),
                                                    dkhpFromMSSVList[
                                                                    indexFromMSSV]
                                                                .lecturersEvaluation !=
                                                            null
                                                        ? Center(
                                                            child: Text(
                                                              '${dkhpFromMSSVList[indexFromMSSV].lecturersEvaluation!.totalScore}',
                                                              style: Style
                                                                  .subtitleStyle,
                                                            ),
                                                          )
                                                        : Center(
                                                            child: Text(
                                                              '-',
                                                              style: Style
                                                                  .subtitleStyle,
                                                            ),
                                                          ),
                                                    InkWell(
                                                      onTap: () async {
                                                        String? sumScoreCanBo =
                                                            await getAllcanBoEvaluation(
                                                                dkhpFromMSSVList[
                                                                        indexFromMSSV]
                                                                    .user
                                                                    .uid!);
                                                        sumScoreAndIdDocParameters
                                                            sumScoreAndIdDocs =
                                                            sumScoreAndIdDocParameters(
                                                          sumScoreCanBo!,
                                                          dkhpFromMSSVList[
                                                                  indexFromMSSV]
                                                              .idDKHP!,
                                                          dkhpFromMSSVList[
                                                                  indexFromMSSV]
                                                              .user
                                                              .fcmToken!,
                                                          dkhpFromMSSVList[
                                                                  indexFromMSSV]
                                                              .user
                                                              .email!,
                                                        );
                                                        // print(sumScoreCanBo);
                                                        if (dkhpFromMSSVList[
                                                                    indexFromMSSV]
                                                                .lockScore ==
                                                            false) {
                                                          Get.toNamed(
                                                            RouteManager
                                                                .lecturersEvaluationDetail,
                                                            arguments:
                                                                sumScoreAndIdDocs,
                                                          );
                                                        } else {
                                                          EasyLoading.showError(
                                                            'Bảng điểm đã bị khóa !',
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 3.1),
                                                        color: primaryColor,
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.edit_rounded,
                                                            color:
                                                                backgroundLite,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

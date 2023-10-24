import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/result_evaluation.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

class LecturersEvaluation extends StatefulWidget {
  const LecturersEvaluation({super.key});

  @override
  State<LecturersEvaluation> createState() => _LecturersEvaluationState();
}

class _LecturersEvaluationState extends State<LecturersEvaluation> {
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
            'Đánh giá kết quả',
            style: Style.homeTitleStyle,
          ),
          backgroundColor: primaryColor,
          actions: [
            InkWell(
              onTap: () async {
                // if (showSearch == false) {
                //   setState(() {
                //     showSearch = true;
                //   });
                // } else {
                //   setState(() {
                //     showSearch = false;
                //   });
                // }
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
                  preferredSize:
                      Size.fromHeight(48.0), // Đặt chiều cao của phần bottom
                  child: Container(
                    color: whiteColor,
                    padding: EdgeInsets.all(1),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        hintText: 'Mã học phần',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      // onChanged: (value) {
                      //   _search = value;
                      //   setState(() {});
                      //   print(_search);
                      // },
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
              dkhpFromMSSVList.add(dkhp);
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
                    1: FixedColumnWidth(70),
                    2: FixedColumnWidth(135),
                    3: FixedColumnWidth(50),
                    4: FixedColumnWidth(50),
                    5: FlexColumnWidth()
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
                    return Table(
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
                                '${indexFromMSSV + 1}',
                                style: Style.subtitleStyle,
                              ),
                            ),
                            Center(
                              child: Text(
                                '${dkhpFromMSSVList[indexFromMSSV].user.MSSV}',
                                style: Style.subtitleStyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                '${dkhpFromMSSVList[indexFromMSSV].user.userName}',
                                style: Style.subtitleStyle,
                              ),
                            ),
                            dkhpFromMSSVList[indexFromMSSV]
                                        .lecturersEvaluation !=
                                    null
                                ? Center(
                                    child: Text(
                                      '${dkhpFromMSSVList[indexFromMSSV].lecturersEvaluation!.total}',
                                      style: Style.subtitleStyle,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      '-',
                                      style: Style.subtitleStyle,
                                    ),
                                  ),
                            dkhpFromMSSVList[indexFromMSSV]
                                        .lecturersEvaluation !=
                                    null
                                ? Center(
                                    child: Text(
                                      '${dkhpFromMSSVList[indexFromMSSV].lecturersEvaluation!.totalScore}',
                                      style: Style.subtitleStyle,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      '-',
                                      style: Style.subtitleStyle,
                                    ),
                                  ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  String? sumScoreCanBo =
                                      await getAllcanBoEvaluation(
                                          dkhpFromMSSVList[indexFromMSSV]
                                              .user
                                              .uid!);
                                  print(sumScoreCanBo);
                                  sumScoreAndIdDocParameters sumScoreAndIdDocs =
                                      sumScoreAndIdDocParameters(
                                          sumScoreCanBo!,
                                          dkhpFromMSSVList[indexFromMSSV]
                                             .idDKHP!);
                                  Get.toNamed(
                                    RouteManager.lecturersEvaluationDetail,
                                    arguments: sumScoreAndIdDocs,
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.1),
                                  color: primaryColor,
                                  child: const Center(
                                    child: Icon(
                                      Icons.edit_rounded,
                                      color: backgroundLite,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

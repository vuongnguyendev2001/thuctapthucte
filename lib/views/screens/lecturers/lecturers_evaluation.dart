import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
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
          // int count = 0;
          // TextEditingController countController =
          //     TextEditingController(text: count.toString());
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  border: TableBorder.all(),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(80),
                    1: FixedColumnWidth(150),
                    2: FlexColumnWidth()
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
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
                            'Điểm',
                            style: Style.titleStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dkhpList.length,
                    itemBuilder: (context, index) {
                      if (dkhpList[index].idGiangVien == loggedInUser.uid) {
                        bool? locationIntern = dkhpList[index].locationIntern;
                        return GestureDetector(
                          onTap: () {
                            
                          },
                          child: Table(
                            border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(80),
                              1: FixedColumnWidth(150),
                              2: FlexColumnWidth()
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      '${dkhpList[index].user.MSSV}',
                                      style: Style.subtitleStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      '${dkhpList[index].user.userName}',
                                      style: Style.subtitleStyle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      child: ElevatedButton(
                                        onPressed: () async {},
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: primaryColor,
                                          side: const BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.check_circle_outline,
                                              color: backgroundLite,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              'Đánh giá',
                                              // 'login'.tr.capitalize,
                                              style: Style.titleStyle.copyWith(
                                                  color: backgroundLite,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // const Center(
                                  //   child: Row(
                                  //     children: [
                                  //       Text('Điểm: Chưa đánh giá'),
                                  //       Icon(
                                  //         Icons.arrow_right_outlined,
                                  //         color: primaryColor,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
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

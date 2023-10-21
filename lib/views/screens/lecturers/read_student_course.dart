import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

class ReadStudentCourse extends StatefulWidget {
  const ReadStudentCourse({super.key});

  @override
  State<ReadStudentCourse> createState() => _ReadStudentCourseState();
}

class _ReadStudentCourseState extends State<ReadStudentCourse> {
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
            'Danh sách sinh viên',
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
                    0: FixedColumnWidth(85),
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
                    itemCount: dkhpList.length,
                    itemBuilder: (context, index) {
                      if (dkhpList[index].idGiangVien == loggedInUser.uid) {
                        bool? locationIntern = dkhpList[index].locationIntern;
                        return Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(85),
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
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${dkhpList[index].user.userName}',
                                        style: Style.subtitleStyle,
                                      ),
                                      Text(
                                        'SĐT: ${dkhpList[index].user.phoneNumber}',
                                        style: Style.subtitleStyle,
                                      ),
                                      Text(
                                        'Lớp: ${dkhpList[index].user.idClass}',
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
                                        children: [
                                          SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Checkbox(
                                              checkColor: primaryColor,
                                              fillColor:
                                                  MaterialStatePropertyAll(
                                                Colors.white70,
                                              ),
                                              value: locationIntern,
                                              onChanged: null,
                                            ),
                                          ),
                                          Text(
                                            'Nơi thực tập',
                                            style: Style.subtitleStyle,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Checkbox(
                                                checkColor: primaryColor,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                  Colors.white70,
                                                ),
                                                value:
                                                    dkhpList[index].receiptForm,
                                                onChanged: null),
                                          ),
                                          Text(
                                            'Phiếu tiếp nhận',
                                            style: Style.subtitleStyle,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Checkbox(
                                                checkColor: primaryColor,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                  Colors.white70,
                                                ),
                                                value: dkhpList[index]
                                                    .assignmentSlipForm,
                                                onChanged: null),
                                          ),
                                          Text(
                                            'Phiếu giao việc',
                                            style: Style.subtitleStyle,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Checkbox(
                                                checkColor: primaryColor,
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                  Colors.white70,
                                                ),
                                                value:
                                                    dkhpList[index].evaluation,
                                                onChanged: null),
                                          ),
                                          Text(
                                            'Cán bộ đánh giá',
                                            style: Style.subtitleStyle,
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

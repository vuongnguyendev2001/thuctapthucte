import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
import 'package:trungtamgiasu/models/course_register.dart';
import 'package:trungtamgiasu/models/receipt_form.dart';
import 'package:trungtamgiasu/models/result_evaluation.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

class InternshipEvaluationScreen extends StatefulWidget {
  const InternshipEvaluationScreen({super.key});

  @override
  State<InternshipEvaluationScreen> createState() =>
      _InternshipEvaluationScreenState();
}

class _InternshipEvaluationScreenState extends State<InternshipEvaluationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  final Stream<QuerySnapshot> resultsEvaluationFirestore = FirebaseFirestore
      .instance
      .collection('ResultsEvaluation')
      .orderBy("userStudent.MSSV")
      .snapshots();
  final Stream<QuerySnapshot> trackingSheetFirestore = FirebaseFirestore
      .instance
      .collection('TrackingSheet')
      .orderBy("mssvController")
      .snapshots();
  final Stream<QuerySnapshot> _SemesterCollection =
      FirebaseFirestore.instance.collection('HocKi').snapshots();
  String? selectedSemester;
  String? selectedAcademicYear;
  bool showSearch = false;
  String _search = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        title: Text(
          'Đánh giá thực tập'.toUpperCase(),
          style: Style.homeTitleStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      hintText: 'Mã số sinh viên hoặc tên sinh viên',
                      prefixIcon: Icon(Icons.search, color: primaryColor),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _search = value;
                      setState(() {});
                      // print(_search);
                    },
                  ),
                ),
              )
            : null,
      ),
      body: StreamBuilder(
        stream: _SemesterCollection,
        builder: (context, snapshot) {
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
              Map<String, dynamic> jsonData =
                  doc.data() as Map<String, dynamic>;
              CourseRegistration courseRegistration =
                  CourseRegistration.fromMap(jsonData);
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
                Container(
                  padding: const EdgeInsets.all(10),
                  color: background,
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
                              .map((academicYear) => DropdownMenuItem<String>(
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
                TabBar(
                  unselectedLabelStyle: Style.homesubtitleStyle,
                  labelColor: primaryColor,
                  indicatorColor: primaryColor,
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      text: 'Phiếu theo dõi',
                    ),
                    Tab(
                      text: 'Phiếu đánh giá kết quả',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
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
                              return StreamBuilder<QuerySnapshot>(
                                  stream: trackingSheetFirestore,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      );
                                    }
                                    List<AssignmentSlip>
                                        assignmentSlipFormList = [];
                                    for (QueryDocumentSnapshot document
                                        in snapshot.data!.docs) {
                                      Map<String, dynamic> data = document
                                          .data() as Map<String, dynamic>;
                                      AssignmentSlip assignmentSlipForm =
                                          AssignmentSlip.fromMap(data);
                                      if (assignmentSlipForm.mssvController.text
                                              .toLowerCase()
                                              .contains(
                                                  _search.toLowerCase()) ||
                                          assignmentSlipForm
                                              .nameStudentController.text
                                              .toLowerCase()
                                              .contains(
                                                  _search.toLowerCase())) {
                                        assignmentSlipFormList
                                            .add(assignmentSlipForm);
                                      }
                                    }

                                    return Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Table(
                                            border: TableBorder.all(),
                                            columnWidths: const <int,
                                                TableColumnWidth>{
                                              0: FixedColumnWidth(30),
                                              1: FixedColumnWidth(90),
                                              2: FixedColumnWidth(170),
                                              3: FlexColumnWidth()
                                            },
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
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
                                                      'Nhận xét',
                                                      textAlign:
                                                          TextAlign.center,
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
                                            itemCount:
                                                assignmentSlipFormList.length,
                                            itemBuilder: (context, index) {
                                              if (assignmentSlipFormList[index]
                                                      .userCanBo!
                                                      .uid ==
                                                  loggedInUser.uid) {
                                                return Column(
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Table(
                                                        border:
                                                            TableBorder.all(),
                                                        columnWidths: const <int,
                                                            TableColumnWidth>{
                                                          0: FixedColumnWidth(
                                                              30),
                                                          1: FixedColumnWidth(
                                                              90),
                                                          2: FixedColumnWidth(
                                                              170),
                                                          3: FlexColumnWidth()
                                                        },
                                                        defaultVerticalAlignment:
                                                            TableCellVerticalAlignment
                                                                .middle,
                                                        children: <TableRow>[
                                                          TableRow(
                                                            children: <Widget>[
                                                              Center(
                                                                child: Text(
                                                                  '${index + 1}',
                                                                  style: Style
                                                                      .subtitleStyle,
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  assignmentSlipFormList[
                                                                          index]
                                                                      .mssvController
                                                                      .text,
                                                                  style: Style
                                                                      .subtitlehomeGiaovuStyle,
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  '${assignmentSlipFormList[index].nameStudentController.text}',
                                                                  style: Style
                                                                      .subtitlehomeGiaovuStyle,
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await Get.toNamed(
                                                                      RouteManager
                                                                          .trackingSheetScreen,
                                                                      arguments:
                                                                          assignmentSlipFormList[index]
                                                                              .id);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          3.1),
                                                                  color:
                                                                      primaryColor,
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .edit_rounded,
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
                                                    ),
                                                  ],
                                                );
                                              }
                                              return null;
                                            }),
                                      ],
                                    );
                                  });
                            }
                          }),
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
                              return StreamBuilder<QuerySnapshot>(
                                stream: resultsEvaluationFirestore,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    );
                                  }
                                  List<ResultEvaluation> resultEvaluationList =
                                      [];
                                  for (QueryDocumentSnapshot document
                                      in snapshot.data!.docs) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    ResultEvaluation resultEvaluation =
                                        ResultEvaluation.fromMap(data);
                                    if (resultEvaluation.userStudent!.MSSV!
                                            .toLowerCase()
                                            .contains(_search.toLowerCase()) ||
                                        resultEvaluation.userStudent!.userName!
                                            .toLowerCase()
                                            .contains(_search.toLowerCase())) {
                                      resultEvaluationList
                                          .add(resultEvaluation);
                                    }
                                  }
                                  return Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Table(
                                          border: TableBorder.all(),
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FixedColumnWidth(30),
                                            1: FixedColumnWidth(85),
                                            2: FixedColumnWidth(160),
                                            3: FixedColumnWidth(55),
                                            4: FlexColumnWidth()
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
                                                    'Điểm',
                                                    style: Style.titleStyle,
                                                    textAlign: TextAlign.center,
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
                                        itemCount: resultEvaluationList.length,
                                        itemBuilder: (context, index) {
                                          if (resultEvaluationList[index]
                                                  .userCanBo!
                                                  .uid ==
                                              loggedInUser.uid) {
                                            return Column(
                                              children: [
                                                const SizedBox(height: 7),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Table(
                                                    border: TableBorder.all(),
                                                    columnWidths: const <int,
                                                        TableColumnWidth>{
                                                      0: FixedColumnWidth(30),
                                                      1: FixedColumnWidth(85),
                                                      2: FixedColumnWidth(160),
                                                      3: FixedColumnWidth(55),
                                                      4: FlexColumnWidth()
                                                    },
                                                    defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .middle,
                                                    children: <TableRow>[
                                                      TableRow(
                                                        children: <Widget>[
                                                          Center(
                                                            child: Text(
                                                              '${index + 1}',
                                                              style: Style
                                                                  .subtitleStyle,
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              '${resultEvaluationList[index].userStudent!.MSSV}',
                                                              style: Style
                                                                  .subtitlehomeGiaovuStyle,
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              '${resultEvaluationList[index].userStudent!.userName}',
                                                              style: Style
                                                                  .subtitlehomeGiaovuStyle,
                                                            ),
                                                          ),
                                                          resultEvaluationList[
                                                                          index]
                                                                      .sumScore ==
                                                                  null
                                                              ? Center(
                                                                  child: Text(
                                                                    '-',
                                                                    style: Style
                                                                        .titleStyle,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                )
                                                              : Center(
                                                                  child: Text(
                                                                    CurrencyFormatter
                                                                        .numFormat(
                                                                            number:
                                                                                double.parse(resultEvaluationList[index].sumScore!)),
                                                                    style: Style
                                                                        .titleStyle,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                          InkWell(
                                                            onTap: () async {
                                                              await Get.toNamed(
                                                                  RouteManager
                                                                      .resultsEvaluationDetail,
                                                                  arguments:
                                                                      resultEvaluationList[
                                                                              index]
                                                                          .id);
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          3.1),
                                                              color:
                                                                  primaryColor,
                                                              child:
                                                                  const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .edit_rounded,
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
                                                ),
                                              ],
                                            );
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

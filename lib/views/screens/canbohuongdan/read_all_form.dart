import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
import 'package:trungtamgiasu/models/receipt_form.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/receipt_form_screen.dart';

class ReadAllForm extends StatefulWidget {
  const ReadAllForm({super.key});

  @override
  State<ReadAllForm> createState() => _ReadAllFormState();
}

class _ReadAllFormState extends State<ReadAllForm>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  String? selectedAcademicYear;
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  final Stream<QuerySnapshot> _receiptFormFirestore =
      FirebaseFirestore.instance.collection('ReceiptForm').snapshots();
  final Stream<QuerySnapshot> _assignmentSlipFormFirestore =
      FirebaseFirestore.instance.collection('AssignmentSlip').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
          title: Text(
            'Các biểu mẫu đã lập'.toUpperCase(),
            style: Style.homeStyle,
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
                      onChanged: (value) {
                        // _search = value;
                        // setState(() {});
                        // print(_search);
                      },
                    ),
                  ),
                )
              : null),
      body: Column(
        children: [
          TabBar(
            unselectedLabelStyle: Style.homesubtitleStyle,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'Phiếu tiếp nhận',
              ),
              Tab(
                text: 'Phiếu giao việc',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                    stream: _receiptFormFirestore,
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

                      List<QueryDocumentSnapshot> documents =
                          snapshot.data!.docs;
                      List<Widget> receiptFormList = [];
                      int index = 1;
                      documents.where((document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        ReceiptForm receiptForm = ReceiptForm.fromMap(data);
                        return receiptForm.userCanBo!.uid == loggedInUser.uid;
                      }).forEach((document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        ReceiptForm receiptForm = ReceiptForm.fromMap(data);
                        Widget item = Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                await Get.toNamed(
                                    RouteManager.readDetailReceiptForm,
                                    arguments: receiptForm.id);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: SingleChildScrollView(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      color: whiteColor,
                                      child: ListTile(
                                        leading: Text(
                                          '$index',
                                          style: Style.subtitleStyle,
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'MSSV: ${receiptForm.userStudent!.MSSV}',
                                              style:
                                                  Style.subtitlehomeGiaovuStyle,
                                            ),
                                            Text(
                                              'Tên SV: ${receiptForm.userStudent!.userName}',
                                              style:
                                                  Style.subtitlehomeGiaovuStyle,
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          'Ngày lập: ${CurrencyFormatter().formattedDatebook(receiptForm.timestamp)}',
                                          // style: Style.subtitleStyle,
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_right_outlined,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                        index++;
                        receiptFormList.add(item);
                      });
                      if (receiptFormList.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Bạn chưa lập phiếu tiếp nhận nào !',
                              style: Style.titleStyle,
                            ),
                          ),
                        );
                      } else {
                        return ListView(
                          children: receiptFormList,
                        );
                      }
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: _assignmentSlipFormFirestore,
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

                      List<QueryDocumentSnapshot> documents =
                          snapshot.data!.docs;
                      List<Widget> assignmentSlipFormList = [];
                      int index = 1;
                      documents.where((document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        AssignmentSlip assignmentSlipForm =
                            AssignmentSlip.fromMap(data);
                        return assignmentSlipForm.userCanBo!.uid ==
                            loggedInUser.uid;
                      }).forEach((document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        AssignmentSlip assignmentSlipForm =
                            AssignmentSlip.fromMap(data);
                        Widget item = Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                await Get.toNamed(
                                    RouteManager.readDetailAssignmentSlip,
                                    arguments: assignmentSlipForm.id);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    color: whiteColor,
                                    child: ListTile(
                                      leading: Text(
                                        '$index',
                                        style: Style.subtitleStyle,
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'MSSV: ${assignmentSlipForm.mssvController.text}',
                                            style:
                                                Style.subtitlehomeGiaovuStyle,
                                          ),
                                          Text(
                                            'Tên SV: ${assignmentSlipForm.nameStudentController.text}',
                                            style:
                                                Style.subtitlehomeGiaovuStyle,
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        'Ngày lập: ${CurrencyFormatter().formattedDatebook(assignmentSlipForm.dateTime)}',
                                        // style: Style.subtitleStyle,
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_right_outlined,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                        index++;
                        assignmentSlipFormList.add(item);
                      });
                      if (assignmentSlipFormList.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Bạn chưa lập phiếu giao việc nào !',
                              style: Style.titleStyle,
                            ),
                          ),
                        );
                      } else {
                        return ListView(
                          children: assignmentSlipFormList,
                        );
                      }
                      // return ListView.builder(
                      //     itemCount: assignmentSlipFormList.length,
                      //     itemBuilder: (context, index) {
                      //       if (assignmentSlipFormList[index].userCanBo!.uid ==
                      //           loggedInUser.uid) {
                      //         return Column(
                      //           children: [
                      //             const SizedBox(
                      //               height: 10,
                      //             ),
                      //             InkWell(
                      //               onTap: () async {
                      //                 await Get.toNamed(
                      //                     RouteManager.readDetailAssignmentSlip,
                      //                     arguments:
                      //                         assignmentSlipFormList[index].id);
                      //               },
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(
                      //                     left: 10, right: 10),
                      //                 child: ClipRRect(
                      //                   borderRadius: BorderRadius.circular(15),
                      //                   child: Container(
                      //                     color: whiteColor,
                      //                     child: ListTile(
                      //                       title: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Text(
                      //                             'MSSV: ${assignmentSlipFormList[index].mssvController.text}',
                      //                             style: Style
                      //                                 .subtitlehomeGiaovuStyle,
                      //                           ),
                      //                           Text(
                      //                             'Tên SV: ${assignmentSlipFormList[index].nameStudentController.text}',
                      //                             style: Style
                      //                                 .subtitlehomeGiaovuStyle,
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       subtitle: Text(
                      //                         'Ngày lập: ${CurrencyFormatter().formattedDatebook(assignmentSlipFormList[index].dateTime)}',
                      //                         // style: Style.subtitleStyle,
                      //                       ),
                      //                       trailing: const Icon(
                      //                         Icons.arrow_right_outlined,
                      //                         color: primaryColor,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         );
                      //       }
                      //       return null;
                      //     });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

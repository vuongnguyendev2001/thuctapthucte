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
                      List<ReceiptForm> receiptFormList = [];
                      for (QueryDocumentSnapshot document
                          in snapshot.data!.docs) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        ReceiptForm receiptForm = ReceiptForm.fromMap(data);
                        receiptFormList.add(receiptForm);
                      }
                      return ListView.builder(
                          itemCount: receiptFormList.length,
                          itemBuilder: (context, index) {
                            if (receiptFormList[index].userCanBo!.uid ==
                                loggedInUser.uid) {
                              TextEditingController mssvStudent =
                                  TextEditingController(
                                      text: receiptFormList[index]
                                          .userStudent!
                                          .MSSV);
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await Get.toNamed(
                                          RouteManager.readDetailReceiptForm,
                                          arguments: receiptFormList[index].id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: SingleChildScrollView(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            color: whiteColor,
                                            child: ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'MSSV: ${receiptFormList[index].userStudent!.MSSV}',
                                                    style: Style
                                                        .subtitlehomeGiaovuStyle,
                                                  ),
                                                  Text(
                                                    'Tên SV: ${receiptFormList[index].userStudent!.userName}',
                                                    style: Style
                                                        .subtitlehomeGiaovuStyle,
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(
                                                'Ngày lập: ${CurrencyFormatter().formattedDatebook(receiptFormList[index].timestamp)}',
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
                            }
                            return null;
                          });
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
                      List<AssignmentSlip> assignmentSlipFormList = [];
                      for (QueryDocumentSnapshot document
                          in snapshot.data!.docs) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        AssignmentSlip assignmentSlipForm =
                            AssignmentSlip.fromMap(data);
                        assignmentSlipFormList.add(assignmentSlipForm);
                      }
                      return ListView.builder(
                          itemCount: assignmentSlipFormList.length,
                          itemBuilder: (context, index) {
                            if (assignmentSlipFormList[index].userCanBo!.uid ==
                                loggedInUser.uid) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await Get.toNamed(
                                          RouteManager.readDetailAssignmentSlip,
                                          arguments:
                                              assignmentSlipFormList[index].id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          color: whiteColor,
                                          child: ListTile(
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'MSSV: ${assignmentSlipFormList[index].mssvController.text}',
                                                  style: Style
                                                      .subtitlehomeGiaovuStyle,
                                                ),
                                                Text(
                                                  'Tên SV: ${assignmentSlipFormList[index].nameStudentController.text}',
                                                  style: Style
                                                      .subtitlehomeGiaovuStyle,
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              'Ngày lập: ${CurrencyFormatter().formattedDatebook(assignmentSlipFormList[index].dateTime)}',
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
                            }
                            return null;
                          });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

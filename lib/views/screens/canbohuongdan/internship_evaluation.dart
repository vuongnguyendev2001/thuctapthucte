import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
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

  final Stream<QuerySnapshot> resultsEvaluationFirestore =
      FirebaseFirestore.instance.collection('ResultsEvaluation').snapshots();
  final Stream<QuerySnapshot> trackingSheetFirestore =
      FirebaseFirestore.instance.collection('TrackingSheet').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Đánh giá thực tập'.toUpperCase(),
          style: Style.homeStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
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
                StreamBuilder<QuerySnapshot>(
                    stream: trackingSheetFirestore,
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
                                          RouteManager.trackingSheetScreen,
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
                                            title: Text(
                                              'MSSV: ${assignmentSlipFormList[index].mssvController.text}',
                                              style:
                                                  Style.subtitlehomeGiaovuStyle,
                                            ),
                                            subtitle: Text(
                                              'Tên SV: ${assignmentSlipFormList[index].nameStudentController.text}',
                                              style:
                                                  Style.subtitlehomeGiaovuStyle,
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
                StreamBuilder<QuerySnapshot>(
                  stream: resultsEvaluationFirestore,
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
                    List<ResultEvaluation> resultEvaluationList = [];
                    for (QueryDocumentSnapshot document
                        in snapshot.data!.docs) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      ResultEvaluation resultEvaluation =
                          ResultEvaluation.fromMap(data);
                      resultEvaluationList.add(resultEvaluation);
                    }
                    return ListView.builder(
                        itemCount: resultEvaluationList.length,
                        itemBuilder: (context, index) {
                          if (resultEvaluationList[index].userCanBo!.uid ==
                              loggedInUser.uid) {
                            TextEditingController mssvStudent =
                                TextEditingController(
                                    text: resultEvaluationList[index]
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
                                        RouteManager.resultsEvaluationDetail,
                                        arguments:
                                            resultEvaluationList[index].id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: SingleChildScrollView(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          color: whiteColor,
                                          child: ListTile(
                                            title: Text(
                                              'MSSV: ${resultEvaluationList[index].userStudent!.MSSV}',
                                              style:
                                                  Style.subtitlehomeGiaovuStyle,
                                            ),
                                            subtitle: Text(
                                              'Tên SV: ${resultEvaluationList[index].userStudent!.userName}',
                                              style:
                                                  Style.subtitlehomeGiaovuStyle,
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
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

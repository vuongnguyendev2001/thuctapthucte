import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/models/work_content.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/mentor/receipt_form_screen.dart';

class TrackingSheetScreen extends StatefulWidget {
  const TrackingSheetScreen({super.key});

  @override
  State<TrackingSheetScreen> createState() => _TrackingSheetScreenState();
}

class _TrackingSheetScreenState extends State<TrackingSheetScreen> {
  String idDocument = ''; // Declare idDocument
  Stream<DocumentSnapshot>? _assignmentSlipFormFirestore;
  TextEditingController evaluationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    idDocument = Get.arguments as String; // Initialize idDocument
    _assignmentSlipFormFirestore = FirebaseFirestore.instance
        .collection('TrackingSheet')
        .doc(idDocument)
        .snapshots();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  CollectionReference DKHPCollection =
      FirebaseFirestore.instance.collection('DangKyHocPhan');
  Future<String?> getAllDKHP(String MSSV) async {
    QuerySnapshot querySnapshot = await DKHPCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DangKyHocPhan dangKyHocPhan = DangKyHocPhan.fromMap(data);
        if (dangKyHocPhan.user.MSSV == MSSV) {
          print(dangKyHocPhan.idDKHP);
          return dangKyHocPhan.idDKHP;
        }
      }
    }
    return 'No data';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Phiếu theo dõi sinh viên'.toUpperCase(),
          style: Style.homeStyle,
        ),
        automaticallyImplyLeading: true,
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: StreamBuilder(
          stream: _assignmentSlipFormFirestore,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            final Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>;
            AssignmentSlip assignmentSlipFormList =
                AssignmentSlip.fromMap(data);
            TextEditingController phoneNumberCanBo = TextEditingController(
                text: assignmentSlipFormList.userCanBo!.phoneNumberCanBo);
            List<TextEditingController> evaluationControllers = List.generate(
              assignmentSlipFormList.workContentControllers!.length,
              (index) => TextEditingController(
                text: assignmentSlipFormList.workContentControllers![index]
                    .trackingWorkContentDetailController?.text,
              ),
            );
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormReceipt(
                                  isReadOnly: true,
                                  controller: assignmentSlipFormList
                                      .nameCanBoController,
                                  lableText: 'Họ và tên cán bộ',
                                  icon: null,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: TextFormReceipt(
                                  isReadOnly: true,
                                  controller: phoneNumberCanBo,
                                  lableText: 'Số điện thoại cán bộ',
                                  icon: null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormReceipt(
                            isReadOnly: true,
                            controller:
                                assignmentSlipFormList.nameCompanyController,
                            lableText: 'Tên cơ quan',
                            icon: const Icon(Icons.abc_outlined),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormReceipt(
                                  isReadOnly: true,
                                  controller: assignmentSlipFormList
                                      .nameStudentController,
                                  lableText: 'Họ và tên SV',
                                  icon: null,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: TextFormReceipt(
                                  isReadOnly: true,
                                  controller:
                                      assignmentSlipFormList.mssvController,
                                  lableText: 'Mã số SV',
                                  icon: null,
                                ),
                              ),
                            ],
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' đến'),
                                TextSpan(
                                    text: ' 8/7/2023',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: assignmentSlipFormList
                                .workContentControllers!.length,
                            itemBuilder: (context, indexWordContent) {
                              // Create the evaluationControllers list

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
                                                    controller: assignmentSlipFormList
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
                                                    controller: assignmentSlipFormList
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
                                              maxline: 1,
                                              controller: assignmentSlipFormList
                                                  .workContentControllers?[
                                                      indexWordContent]
                                                  .workContentDetailController,
                                              lableText:
                                                  'Nội dung công việc được giao',
                                              icon: const Icon(
                                                  Icons.abc_outlined),
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormReceipt(
                                              maxline: 1,
                                              controller: evaluationControllers[
                                                  indexWordContent],
                                              onChanged: (value) {
                                                // Update the trackingWorkContentDetailController when the user types.
                                                assignmentSlipFormList
                                                    .workContentControllers![
                                                        indexWordContent]
                                                    .trackingWorkContentDetailController
                                                    ?.text = value;
                                              },
                                              lableText:
                                                  'Nhận xét của CB hướng dẫn',
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
                          assignmentSlipFormList.dateTime != null
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Người đánh giá: ${assignmentSlipFormList.userCanBo!.userName}',
                                      ),
                                      Text(
                                        'Ngày đánh giá: ${CurrencyFormatter().formattedDatebook(assignmentSlipFormList.dateTime)}',
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 60)
                        ],
                      ),
                    ),
                  ),
                ),
                loggedInUser.uid == assignmentSlipFormList.userCanBo!.uid
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: Get.width,
                          height: 55,
                          color: greyFontColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 50,
                                width: Get.width * 0.7,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          List<WorkContent>? workContentNew =
                                              assignmentSlipFormList
                                                  .workContentControllers;
                                          List<Map<String, dynamic>>?
                                              workContentMaps = workContentNew
                                                  ?.map((workContent) {
                                            return workContent
                                                .toMap(); // Convert each WorkContent object to a Map
                                          }).toList();
                                          await FirebaseFirestore.instance
                                              .collection('TrackingSheet')
                                              .doc(idDocument)
                                              .update({
                                            "workContentControllers":
                                                workContentMaps,
                                            "dateTime": Timestamp.now()
                                          }).then((_) async {
                                            String? idDKHP = await getAllDKHP(
                                                assignmentSlipFormList
                                                    .mssvController.text);
                                            await FirebaseFirestore.instance
                                                .collection('DangKyHocPhan')
                                                .doc(idDKHP)
                                                .update(
                                                    {'evaluationWork': true});
                                            Loading().isShowSuccess(
                                                'Đã lưu thông tin phiếu');
                                          }).catchError((error) {
                                            // Xử lý lỗi nếu có khi cập nhật
                                            print(
                                                'Lỗi khi cập nhật ID của tài liệu: $error');
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(Get.width, 44),
                                          elevation: 0.0,
                                          backgroundColor: primaryColor,
                                          side: const BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.check_circle_outline,
                                              color: backgroundLite,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              'Hoàn thành phiếu',
                                              // 'login'.tr.capitalize,
                                              style: Style.titleStyle.copyWith(
                                                  color: backgroundLite,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: whiteColor,
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}

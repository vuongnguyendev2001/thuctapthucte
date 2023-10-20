import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/models/work_content.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/receipt_form_screen.dart';

class AssignmentSlipScreen extends StatefulWidget {
  const AssignmentSlipScreen({super.key});

  @override
  State<AssignmentSlipScreen> createState() => _AssignmentSlipScreenState();
}

class _AssignmentSlipScreenState extends State<AssignmentSlipScreen> {
  @override
  void initState() {
    super.initState();
    RegisterViewerArguments? arguments =
        Get.arguments as RegisterViewerArguments?;
    _nameCompanyController.text = arguments!.companyIntern.name;
    _nameStudentController.text = arguments.userModel.userName!;
    _mssvController.text = arguments.userModel.MSSV!;
    getUserForCompany(arguments.companyIntern);
    fetchData();
    for (int i = 0; i < 8; i++) {
      addContainer();
    }
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  Future<void> getUserForCompany(CompanyIntern company) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(company.idUserCanBo)
        .get();
    if (userSnapshot.exists) {
      try {
        UserModel user =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        setState(() {
          _nameCanBoController.text = user.userName!;
        });
      } catch (e) {
        print(e);
      }
    } else {
      print('null');
    }
  }

  Timestamp? timestamp = Timestamp.now();
  List<Widget> containers = [];
  final TextEditingController _nameCompanyController = TextEditingController();
  final TextEditingController _nameCanBoController = TextEditingController();
  final TextEditingController _nameStudentController = TextEditingController();
  final TextEditingController _mssvController = TextEditingController();

  List<WorkContent> workContentControllers = [];
  // final List<TextEditingController> weekNumberControllers = [];
  int weekNumber = 1;
  void addContainer() {
    TextEditingController weekNumberController =
        TextEditingController(text: weekNumber.toString());
    TextEditingController sessionNumberController =
        TextEditingController(text: '8h/buổi, 6buổi/tuần');
    TextEditingController workContentDetailController = TextEditingController();
    setState(
      () {
        weekNumber++;
        containers.add(
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
                          controller: weekNumberController,
                          lableText: 'Tuần',
                          icon: null,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: TextFormReceipt(
                          controller: sessionNumberController,
                          lableText: 'Số buổi (VD: 6h/buổi, 6b/tuần)',
                          icon: null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormReceipt(
                    controller: workContentDetailController,
                    lableText: 'Nội dung công việc được giao',
                    icon: const Icon(Icons.abc_outlined),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    // weekNumberControllers.add(weekNumberController);
    workContentControllers.add(
      WorkContent(
        weekNumberController: weekNumberController,
        sessionNumberController: sessionNumberController,
        workContentDetailController: workContentDetailController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('Phiếu giao việc sinh viên'.toUpperCase(),
            style: Style.homeStyle),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormReceipt(
                            controller: _nameStudentController,
                            lableText: 'Họ và tên SV',
                            icon: null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextFormReceipt(
                            controller: _mssvController,
                            lableText: 'Mã số SV',
                            icon: null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormReceipt(
                      controller: _nameCompanyController,
                      lableText: 'Tên cơ quan',
                      icon: const Icon(Icons.abc_outlined),
                    ),
                    const SizedBox(height: 15),
                    TextFormReceipt(
                      controller: _nameCanBoController,
                      lableText: 'Họ và tên cán bộ',
                      icon: const Icon(Icons.abc_outlined),
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' đến'),
                          TextSpan(
                              text: ' 8/7/2023',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(10),
                    //   child: Container(
                    //     width: Get.width,
                    //     color: whiteColor,
                    //     padding: const EdgeInsets.all(15),
                    //     child: Column(
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Expanded(
                    //               flex: 2,
                    //               child: TextFormReceipt(
                    //                 controller: _weekNumberController,
                    //                 lableText: 'Tuần',
                    //                 icon: null,
                    //               ),
                    //             ),
                    //             const SizedBox(width: 5),
                    //             Expanded(
                    //               flex: 4,
                    //               child: TextFormReceipt(
                    //                 controller: _sessionNumberController,
                    //                 lableText: 'Số buổi (VD: 6h/buổi, 6b/tuần)',
                    //                 icon: null,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         const SizedBox(height: 10),
                    //         TextFormReceipt(
                    //           maxline: 2,
                    //           controller: _workContentDetailController,
                    //           lableText: 'Nội dung công việc được giao',
                    //           icon: const Icon(Icons.abc_outlined),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: containers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            containers[index],
                            const SizedBox(height: 10)
                          ],
                        );
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                              color:
                                  whiteColor, // Change this color to your desired text color
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white54)),
                      onPressed: () {
                        addContainer();
                      },
                      child: const Text('Thêm tuần'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
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
                              AssignmentSlip assignmentForm = AssignmentSlip(
                                mssvController: _mssvController,
                                nameCanBoController: _nameCanBoController,
                                nameCompanyController: _nameCompanyController,
                                nameStudentController: _nameStudentController,
                                workContentControllers: workContentControllers,
                                userCanBo: loggedInUser,
                                dateTime: timestamp!,
                              );
                              AssignmentSlip trackingSheetForm = AssignmentSlip(
                                mssvController: _mssvController,
                                nameCanBoController: _nameCanBoController,
                                nameCompanyController: _nameCompanyController,
                                nameStudentController: _nameStudentController,
                                workContentControllers: workContentControllers,
                                userCanBo: loggedInUser,
                              );
                              Map<String, dynamic> dataassignmentForm =
                                  assignmentForm.toMap();
                              await FirebaseFirestore.instance
                                  .collection('AssignmentSlip')
                                  .add(dataassignmentForm)
                                  .then((documentReference) {
                                String documentId = documentReference.id;
                                documentReference.update({
                                  'id': documentId,
                                }).then((_) {
                                  // In ID của tài liệu sau khi đã cập nhật
                                  Loading()
                                      .isShowSuccess('Lập phiếu thành công');
                                  Get.back();
                                  print(
                                      'ID của tài liệu vừa được thêm và cập nhật: $documentId');
                                }).catchError((error) {
                                  // Xử lý lỗi nếu có khi cập nhật
                                  print(
                                      'Lỗi khi cập nhật ID của tài liệu: $error');
                                });
                              }).catchError((error) {
                                // Xử lý lỗi nếu có khi thêm tài liệu
                                print('Lỗi khi thêm tài liệu: $error');
                              });
                              Map<String, dynamic> dataTrackingSheet =
                                  trackingSheetForm.toMap();
                              await FirebaseFirestore.instance
                                  .collection('TrackingSheet')
                                  .add(dataTrackingSheet)
                                  .then((documentReference) {
                                String documentId = documentReference.id;
                                documentReference.update({
                                  'id': documentId,
                                }).then((_) {
                                  // In ID của tài liệu sau khi đã cập nhật

                                  print(
                                      'ID của tài liệu vừa được thêm và cập nhật: $documentId');
                                }).catchError((error) {
                                  // Xử lý lỗi nếu có khi cập nhật
                                  print(
                                      'Lỗi khi cập nhật ID của tài liệu: $error');
                                });
                              }).catchError((error) {
                                // Xử lý lỗi nếu có khi thêm tài liệu
                                print('Lỗi khi thêm tài liệu: $error');
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
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      color: backgroundLite, fontSize: 16),
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
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                      radius: 20,
                      backgroundColor: whiteColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

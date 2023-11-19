import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/constants/ui_helper.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
import 'package:trungtamgiasu/models/course_register.dart';
import 'package:trungtamgiasu/models/notification.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/receipt_form.dart';
import 'package:trungtamgiasu/models/registration_model.dart';
import 'package:trungtamgiasu/models/user/intership_appycation_model.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/firebase_api.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ApprovingInternshipsScreen extends StatefulWidget {
  const ApprovingInternshipsScreen({super.key});

  @override
  State<ApprovingInternshipsScreen> createState() =>
      _ApprovingInternshipsScreenState();
}

class _ApprovingInternshipsScreenState
    extends State<ApprovingInternshipsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  UserModel studentModel = UserModel();
  UserModel loggedInUser = UserModel();
  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('registrations').snapshots();
  CollectionReference internshipApplicationsCollection =
      FirebaseFirestore.instance.collection('registrations');
  final Stream<QuerySnapshot> _SemesterCollection =
      FirebaseFirestore.instance.collection('HocKi').snapshots();
  Future<bool?> getAllApplications(String userID, String companyID) async {
    QuerySnapshot querySnapshot = await internshipApplicationsCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        RegistrationModel internshipApplication =
            RegistrationModel.fromMap(data);
        if (internshipApplication.user.uid == userID &&
            internshipApplication.Company.id == companyID) {
          print('true');
          return true;
        }
      }
    } else {
      print('false');
      return false;
    }
  }

  CollectionReference DKHPCollection =
      FirebaseFirestore.instance.collection('DangKyHocPhan');
  Future<String?> getAllDKHP(String userID) async {
    QuerySnapshot querySnapshot = await DKHPCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DangKyHocPhan dangKyHocPhan = DangKyHocPhan.fromMap(data);
        if (dangKyHocPhan.user.uid == userID) {
          print(dangKyHocPhan.idDKHP);
          return dangKyHocPhan.idDKHP;
        }
      }
    }
    return 'No data';
  }

  String? selectedSemester;
  String? selectedAcademicYear;
  CollectionReference receiptForm =
      FirebaseFirestore.instance.collection('ReceiptForm');

  Future<bool?> getAllReceiptForm(String userID, String companyID) async {
    QuerySnapshot querySnapshot = await receiptForm.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        ReceiptForm receiptForm = ReceiptForm.fromMap(data);
        if (receiptForm.userStudent!.uid == userID &&
            receiptForm.companyIntern!.id == companyID) {
          return true;
        }
      }
    }
    return false;
  }

  CollectionReference assignmentForm =
      FirebaseFirestore.instance.collection('AssignmentSlip');
  Future<bool?> getAllAssignmentSlipForm(String MSSV) async {
    QuerySnapshot querySnapshot = await assignmentForm.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        AssignmentSlip receiptForm = AssignmentSlip.fromMap(data);
        if (receiptForm.mssvController.text == MSSV) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Danh sách sinh viên chờ duyệt',
          style: Style.homeTitleStyle,
        ),
        centerTitle: true,
      ),
      body: ListToReview(),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> ListToReview() {
    return StreamBuilder<QuerySnapshot>(
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
            Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
            CourseRegistration courseRegistration =
                CourseRegistration.fromMap(jsonData);
            courseRegistrations.add(courseRegistration);
            print(courseRegistration.id);
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
          selectedAcademicYear ??=
              uniqueAcademicYears.isNotEmpty ? uniqueAcademicYears.first : null;

          return Column(
            children: [
              Container(
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
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: courseRegistrations.length,
                    itemBuilder: (context, index) {
                      CourseRegistration courseRegistration =
                          courseRegistrations[index];

                      if (courseRegistration.semester == selectedSemester &&
                          courseRegistration.academicYear ==
                              selectedAcademicYear) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: _usersStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                loggedInUser.uid == null) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              );
                            }
                            Map<String, dynamic> dataToUpdate = {
                              'status': 'Đã duyệt',
                            };
                            List<QueryDocumentSnapshot> documents =
                                snapshot.data!.docs;
                            List<Widget> internshipApplications = [];
                            int index = 1;
                            documents.where((document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              RegistrationModel internshipApplication =
                                  RegistrationModel.fromMap(data);
                              return internshipApplication.Company.id ==
                                  loggedInUser.idCompany;
                            }).forEach(
                              (document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                RegistrationModel internshipApplication =
                                    RegistrationModel.fromMap(data);
                                Widget item = Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                          // isScrollControlled: true,
                                          enableDrag: false,
                                          backgroundColor: background,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SizedBox(
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    height: Get.height,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                              'Hồ sơ ứng tuyển'
                                                                  .toUpperCase(),
                                                              style: Style
                                                                  .hometitleStyle
                                                                  .copyWith(
                                                                      color:
                                                                          primaryColor)),
                                                        ),
                                                        Text(
                                                          'Vị trí ứng tuyển: ${internshipApplication.positionApply}',
                                                        ),
                                                        Text(
                                                          'Gmail: ${internshipApplication.user.email}',
                                                        ),
                                                        Text(
                                                          'Họ và tên: ${internshipApplication.user.userName}',
                                                        ),
                                                        Text(
                                                          'Số điện thoại: ${internshipApplication.user.phoneNumber}',
                                                        ),
                                                        Text(
                                                          'Địa chỉ: ${internshipApplication.user.address}',
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            PdfViewerArguments
                                                                arguments =
                                                                PdfViewerArguments(
                                                              internshipApplication
                                                                  .urlCV,
                                                              internshipApplication
                                                                  .nameCV,
                                                            );
                                                            Get.toNamed(
                                                                RouteManager
                                                                    .pdfViewer,
                                                                arguments:
                                                                    arguments);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              const Text(
                                                                  'CV: '),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                width: 100,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  color:
                                                                      primaryColor,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .remove_red_eye,
                                                                      color:
                                                                          whiteColor,
                                                                    ),
                                                                    Text(
                                                                      ' Xem CV',
                                                                      style: TextStyle(
                                                                          color:
                                                                              whiteColor),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                  Container(
                                                    width: Get.width,
                                                    height: 55,
                                                    color: greyFontColor,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SizedBox(
                                                          height: 50,
                                                          width:
                                                              Get.width * 0.7,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      UIHelper
                                                                          .showCupertinoDialog(
                                                                        onComfirm:
                                                                            () async {
                                                                          Notifications
                                                                              notification =
                                                                              Notifications(
                                                                            title:
                                                                                'Trúng tuyển thực tập',
                                                                            body:
                                                                                'Bạn đã được duyệt thực tập tại công ty ${internshipApplication.Company.name}',
                                                                            timestamp:
                                                                                Timestamp.now(),
                                                                            emailUser:
                                                                                internshipApplication.user.email!,
                                                                          );
                                                                          print(internshipApplication
                                                                              .user
                                                                              .fcmToken!);
                                                                          await FirebaseApi()
                                                                              .sendFirebaseCloudMessage(
                                                                            notification.title,
                                                                            notification.body,
                                                                            internshipApplication.user.fcmToken!,
                                                                          );
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection('notifications')
                                                                              .add(
                                                                                notification.toJson(),
                                                                              );
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection('registrations')
                                                                              .doc(internshipApplication.id)
                                                                              .update(
                                                                                dataToUpdate,
                                                                              );
                                                                          String?
                                                                              idDKHP =
                                                                              await getAllDKHP(internshipApplication.user.uid!);
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  'DangKyHocPhan')
                                                                              .doc(
                                                                                  idDKHP)
                                                                              .update({
                                                                            'locationIntern':
                                                                                true
                                                                          });
                                                                          EasyLoading.showSuccess(
                                                                              'Duyệt thành công !');
                                                                          Get.back();
                                                                          Get.back();
                                                                        },
                                                                        titleConfirm:
                                                                            'Chấp nhận',
                                                                        titleClose:
                                                                            'Đóng',
                                                                        isShowClose:
                                                                            true,
                                                                        title:
                                                                            'Thông báo',
                                                                        message:
                                                                            'Đồng ý nhận sinh viên thực tập',
                                                                      );

                                                                      // UIHelper.showFlushbar(
                                                                      //     message:
                                                                      //         'Đăng ký thành công !');
                                                                    } catch (e) {
                                                                      print(e);
                                                                    } finally {
                                                                      await Loading()
                                                                          .isOffShowLoading();
                                                                    }
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    minimumSize:
                                                                        Size(
                                                                            Get.width,
                                                                            44),
                                                                    elevation:
                                                                        0.0,
                                                                    backgroundColor:
                                                                        primaryColor,
                                                                    side:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    'Chấp nhận',
                                                                    // 'login'.tr.capitalize,
                                                                    style: Style
                                                                        .titleStyle
                                                                        .copyWith(
                                                                            color:
                                                                                backgroundLite,
                                                                            fontSize:
                                                                                16),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'registrations')
                                                                          .doc(internshipApplication
                                                                              .id)
                                                                          .update({
                                                                        'status':
                                                                            'Từ chối'
                                                                      });
                                                                      Get.back();
                                                                    } catch (e) {
                                                                      print(e);
                                                                    } finally {
                                                                      await Loading()
                                                                          .isOffShowLoading();
                                                                    }
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    minimumSize:
                                                                        Size(
                                                                            Get.width,
                                                                            44),
                                                                    elevation:
                                                                        0.0,
                                                                    backgroundColor:
                                                                        primaryOpacity,
                                                                    side:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    'Từ chối',
                                                                    // 'login'.tr.capitalize,
                                                                    style: Style
                                                                        .titleStyle
                                                                        .copyWith(
                                                                            color:
                                                                                backgroundLite,
                                                                            fontSize:
                                                                                16),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: CircleAvatar(
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 20,
                                                            ),
                                                            radius: 20,
                                                            backgroundColor:
                                                                whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
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
                                                'Vị trí ứng tuyển: ${internshipApplication.positionApply}',
                                              ),
                                              Text(
                                                'Họ và tên: ${internshipApplication.user.userName}',
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Trạng thái: ',
                                                  style: Style.subtitleStyle,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          internshipApplication
                                                              .status,
                                                      style:
                                                          internshipApplication
                                                                      .status ==
                                                                  'Đã duyệt'
                                                              ? Style
                                                                  .subtitleStyle
                                                                  .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      dashTeal,
                                                                )
                                                              : Style
                                                                  .subtitleStyle
                                                                  .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      primaryOpacity,
                                                                ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              if (internshipApplication
                                                      .status ==
                                                  'Đã duyệt')
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () async {
                                                          bool checkForm =
                                                              await getAllReceiptForm(
                                                                  internshipApplication
                                                                      .user
                                                                      .uid!,
                                                                  internshipApplication
                                                                      .Company
                                                                      .id!) as bool;
                                                          if (checkForm ==
                                                              false) {
                                                            RegisterViewerArguments
                                                                arguments =
                                                                RegisterViewerArguments(
                                                                    internshipApplication
                                                                        .user,
                                                                    internshipApplication
                                                                        .Company,
                                                                    internshipApplication
                                                                        .idDKHP);
                                                            await Get.toNamed(
                                                              RouteManager
                                                                  .receiptFormScreen,
                                                              arguments:
                                                                  arguments,
                                                            );
                                                          } else {
                                                            await Loading()
                                                                .isshowError(
                                                                    'Bạn đã lập phiếu cho sinh viên rồi');
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          width: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            color: primaryColor,
                                                          ),
                                                          child: Text(
                                                            'Lập phiếu tiếp nhận',
                                                            style: TextStyle(
                                                              color: whiteColor,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () async {
                                                          bool checkForm =
                                                              await getAllAssignmentSlipForm(
                                                                      internshipApplication
                                                                          .user
                                                                          .MSSV!)
                                                                  as bool;
                                                          if (checkForm ==
                                                              false) {
                                                            RegisterViewerArguments
                                                                arguments =
                                                                RegisterViewerArguments(
                                                                    internshipApplication
                                                                        .user,
                                                                    internshipApplication
                                                                        .Company,
                                                                    internshipApplication
                                                                        .idDKHP);
                                                            await Get.toNamed(
                                                              RouteManager
                                                                  .assignmentSlip,
                                                              arguments:
                                                                  arguments,
                                                            );
                                                          } else {
                                                            await Loading()
                                                                .isshowError(
                                                                    'Bạn đã lập phiếu cho sinh viên rồi');
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          width: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                            color: primaryColor,
                                                          ),
                                                          child: Text(
                                                            'Lập phiếu giao việc',
                                                            style: TextStyle(
                                                              color: whiteColor,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              else
                                                const SizedBox(),
                                              Text(
                                                'Ngày đăng ký: ${CurrencyFormatter().formattedDatebook(internshipApplication.timestamp)}',
                                                style: Style.subtitleStyle,
                                              ),
                                            ],
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_right_outlined,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                                index++;
                                if (courseRegistration.id ==
                                        internshipApplication.idDKHP &&
                                    courseRegistration.semester ==
                                        selectedSemester &&
                                    courseRegistration.academicYear ==
                                        selectedAcademicYear) {
                                  internshipApplications.add(item);
                                }
                              },
                            );
                            if (internshipApplications.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Chưa có sinh viên đăng ký',
                                    style: Style.titleStyle,
                                  ),
                                ),
                              );
                            } else {
                              return ListView(
                                shrinkWrap: true,
                                children: internshipApplications,
                              );
                            }
                          },
                        );
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  PDFDocument? document;
  String urlCV = '';
  String title = '';
  @override
  void initState() {
    super.initState();
    PdfViewerArguments? arguments = Get.arguments as PdfViewerArguments?;
    urlCV = arguments!.urlCV;
    title = arguments.title;
    initPdf();
  }

  void initPdf() async {
    document = await PDFDocument.fromURL(urlCV);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PdfViewerArguments? arguments = Get.arguments as PdfViewerArguments?;
    String urlCV = arguments!.urlCV;
    String title = arguments.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Style.subtitleStyle.copyWith(fontSize: 16),
        ),
      ),
      body: Center(
        child: document != null
            ? PDFViewer(document: document!)
            : const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
      ),
    );
  }
}

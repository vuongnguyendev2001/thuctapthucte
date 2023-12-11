import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/timeline_student.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

import '../../../constants/color.dart';
import '../../../constants/currency_formatter.dart';
import '../../../constants/style.dart';
import '../../../controllers/route_manager.dart';
import '../../../services/login_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    fetchData();
    timeLine();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
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

  DateTime? endDateRegisterCourseAndCompanyDateTime;
  DateTime? endDateCheckReceiptAndAssignmentDateTime;
  DateTime? endDateSubmitReportDateTime;
  String startDateRegisterCourseAndCompany = "Chưa đặt thời gian";
  String endDateRegisterCourseAndCompany = "";
  String startDateCheckReceiptAndAssignment = "Chưa đặt thời gian";
  String endDateCheckReceiptAndAssignment = "";
  String startDateStartIntern = "Chưa đặt thời gian";
  String endDateStartIntern = "";
  String startDateSubmitReport = "Chưa đặt thời gian";
  String endDateSubmitReport = "";
  String startDateHaveScore = "Chưa đặt thời gian";
  String endDateHaveScore = "";
  DateTimeRange selectionDate = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  void timeLine() {
    FirebaseFirestore.instance
        .collection("ManagementTimeline")
        .doc("sinhvien")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            TimelineStudentModel timelineStudentModel =
                TimelineStudentModel.fromJson(data);
            startDateRegisterCourseAndCompany = CurrencyFormatter()
                .formattedDate(
                    timelineStudentModel.courseRegisterAndCompany!.startDate);
            endDateRegisterCourseAndCompany = CurrencyFormatter().formattedDate(
                timelineStudentModel.courseRegisterAndCompany!.endDate);
            endDateRegisterCourseAndCompanyDateTime =
                timelineStudentModel.courseRegisterAndCompany!.endDate;
            startDateCheckReceiptAndAssignment = CurrencyFormatter()
                .formattedDate(
                    timelineStudentModel.checkReceiptAndAssignment!.startDate);
            endDateCheckReceiptAndAssignmentDateTime =
                timelineStudentModel.checkReceiptAndAssignment!.endDate;
            endDateCheckReceiptAndAssignment = CurrencyFormatter()
                .formattedDate(
                    timelineStudentModel.checkReceiptAndAssignment!.endDate);
            startDateStartIntern = CurrencyFormatter()
                .formattedDate(timelineStudentModel.startIntern!.startDate);
            endDateStartIntern = CurrencyFormatter().formattedDate(
              timelineStudentModel.startIntern!.endDate,
            );
            startDateSubmitReport = CurrencyFormatter()
                .formattedDate(timelineStudentModel.submitReport!.startDate);
            startDateSubmitReport = CurrencyFormatter().formattedDate(
              timelineStudentModel.submitReport!.endDate,
            );
            endDateSubmitReportDateTime =
                timelineStudentModel.submitReport!.endDate;
            endDateSubmitReport = CurrencyFormatter()
                .formattedDate(timelineStudentModel.submitReport!.endDate);
            startDateHaveScore = CurrencyFormatter()
                .formattedDate(timelineStudentModel.haveScore!.startDate);
            endDateHaveScore = CurrencyFormatter().formattedDate(
              timelineStudentModel.haveScore!.endDate,
            );
          });
        } else {
          print('Document data is null');
        }
      } else {
        print('Document have on the database');
      }
    });
  }

  List<Step> stepList() => [
        Step(
          state:
              _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Đăng ký học phần & Đăng ký công ty'),
              Text(
                '$startDateRegisterCourseAndCompany đến $endDateRegisterCourseAndCompany',
                style: Style.homesubtitleStyle.copyWith(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          content: const Center(
            child: Text(
                'Sinh viên đăng ký đúng nhóm học phần của lớp mình. Sau khi đăng ký thành công, sinh viên sẽ đăng ký công ty thực tập phù hợp và chờ được xét duyệt.'),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 1,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Kiểm tra phiếu giao việc & tiếp nhận'),
              Text(
                '$startDateCheckReceiptAndAssignment đến $endDateCheckReceiptAndAssignment',
                style: Style.homesubtitleStyle.copyWith(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          content: const Center(
            child: Text(
              'Sau khi được xét duyệt bởi công ty, sinh viên sẽ kiểm tra thông tin của phiếu tiếp nhận & giao việc để biết thông tin thực tập.',
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 2,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Bắt đầu thực tập (8 tuần)'),
              Text(
                '$startDateStartIntern đến $endDateStartIntern',
                style: Style.homesubtitleStyle.copyWith(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          content: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sinh viên bắt đầu quá trình đi thực tập.',
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 3 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 3,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Nộp báo cáo thực tập'),
              Text(
                '$startDateSubmitReport đến $endDateSubmitReport',
                style: Style.homesubtitleStyle.copyWith(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          content: const Center(
            child: Text(
                'Sau khi thực tập xong, sinh viên sẽ nộp báo cáo cho giảng viên chấm điểm.'),
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeCurrentStep >= 4,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Kết quả học tập'),
              Text(
                '$startDateHaveScore đến $endDateHaveScore',
                style: Style.homesubtitleStyle.copyWith(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          content: const Center(
            child: Text(
              'Sinh viên chờ giảng viên lên điểm và xem ở phần "kết quả học tập".',
            ),
          ),
        )
      ];
  int _activeCurrentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      // drawer: Column(children: []),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-ctu.png',
              height: 40,
              width: 40,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Xin chào,', style: Style.subtitleStyle),
                  loggedInUser.userName != null
                      ? Text(loggedInUser.userName.toString(),
                          style: Style.titleStyle)
                      : Text('Đang tải', style: Style.titleStyle)
                ],
              ),
              const SizedBox(width: 10),
              loggedInUser.avatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CircleAvatar(
                        radius: 23,
                        child: Image.network(loggedInUser.avatar.toString()),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CircleAvatar(
                        radius: 23,
                        child: Image.asset('assets/images/user.png'),
                      ),
                    ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: accentColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (endDateRegisterCourseAndCompanyDateTime!
                                  .compareTo(DateTime.now()) <
                              0) {
                            EasyLoading.showError(
                              'Đã hết thời gian\nđăng ký học phần !',
                            );
                          }
                          if (endDateRegisterCourseAndCompanyDateTime!
                                  .compareTo(DateTime.now()) >
                              0) {
                            Get.toNamed(RouteManager.courseRegistrationScreen);
                          }
                        },
                        child: SizedBox(
                          width: 65,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icon_svg/note.svg',
                                width: 45, // Kích thước chiều rộng
                                height: 45, // Kích thước chiều cao
                              ),
                              SizedBox(
                                height: 40,
                                child: Text(
                                  'Đăng ký học phần',
                                  style: Style.homesubtitleStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (endDateRegisterCourseAndCompanyDateTime!
                                  .compareTo(DateTime.now()) <
                              0) {
                            EasyLoading.showError(
                              'Đã hết thời gian đăng ký\nđịa điểm thực tập !',
                            );
                          }
                          if (endDateRegisterCourseAndCompanyDateTime!
                                  .compareTo(DateTime.now()) >
                              0) {
                            Get.toNamed(RouteManager.timKiemDiaDiem);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 92,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icon_svg/searchaddress.svg',
                                width: 45, // Kích thước chiều rộng
                                height: 45, // Kích thước chiều cao
                              ),
                              SizedBox(
                                height: 40,
                                child: Text(
                                  'Tìm kiếm địa điểm thực tập',
                                  style: Style.homesubtitleStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(RouteManager.diadiemdadangky),
                        child: SizedBox(
                          width: 78,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icon_svg/list.svg',
                                width: 45, // Kích thước chiều rộng
                                height: 45, // Kích thước chiều cao
                              ),
                              SizedBox(
                                child: Text(
                                  'Địa điểm đã đăng ký',
                                  style: Style.homesubtitleStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: accentColor,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Get.toNamed(RouteManager.assignmentAndReceipt);
                      },
                      child: SizedBox(
                        width: 105,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icon_svg/note.svg',
                              width: 45, // Kích thước chiều rộng
                              height: 45, // Kích thước chiều cao
                            ),
                            SizedBox(
                              child: Text(
                                'Phiếu tiếp nhận Phiếu giao việc',
                                style: Style.homesubtitleStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (endDateSubmitReportDateTime!
                                .compareTo(DateTime.now()) <
                            0) {
                          EasyLoading.showError(
                            'Đã hết thời gian\nnộp báo cáo !',
                          );
                        }
                        if (endDateSubmitReportDateTime!
                                .compareTo(DateTime.now()) >
                            0) {
                          String? idDKHP = await getAllDKHP(loggedInUser.uid!);
                          await Get.toNamed(RouteManager.submitReport,
                              arguments: idDKHP);
                        }
                      },
                      child: SizedBox(
                        width: 85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icon_svg/list.svg',
                              width: 45, // Kích thước chiều rộng
                              height: 45, // Kích thước chiều cao
                            ),
                            SizedBox(
                              child: Text(
                                'Nộp báo cáo thực tập',
                                style: Style.homesubtitleStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String? idDKHP = await getAllDKHP(loggedInUser.uid!);
                        await Get.toNamed(RouteManager.learningOutcomes,
                            arguments: idDKHP);
                      },
                      child: SizedBox(
                        width: 68,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icon_svg/searchaddress.svg',
                              width: 45, // Kích thước chiều rộng
                              height: 45, // Kích thước chiều cao
                            ),
                            SizedBox(
                              width: 75,
                              child: Text(
                                'Kết quả học tập',
                                style: Style.homesubtitleStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Quy trình thực tập của sinh viên',
              style: Style.hometitleStyle,
            ),
          ),
          Expanded(
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _activeCurrentStep,
              steps: stepList(),
              onStepContinue: () {
                if (_activeCurrentStep < (stepList().length - 1)) {
                  setState(() {
                    _activeCurrentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if (_activeCurrentStep == 0) {
                  return;
                }
                setState(() {
                  _activeCurrentStep -= 1;
                });
              },
              connectorColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    // Color when the step is disabled
                    return Colors.grey;
                  } else {
                    // Color for the active step
                    return primaryColor;
                  }
                },
              ),
              onStepTapped: (int index) {
                setState(() {
                  _activeCurrentStep = index;
                });
              },
              controlsBuilder:
                  (BuildContext context, ControlsDetails controlsDetails) {
                if (_activeCurrentStep == stepList().length - 1) {
                  return Container(); // Return an empty container to hide controls on the last step
                }

                return Row(
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(
                            fontSize: 16, // Set the font size
                            fontWeight: FontWeight.bold, // Set the font weight
                            color: Colors.white, // Set the text color
                          ),
                        ),
                      ),
                      onPressed: controlsDetails.onStepContinue,
                      child: Text(
                        'Bước kế tiếp',
                        style: Style.homesubtitleStyle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(greyFontColor),
                      ),
                      onPressed: controlsDetails.onStepCancel,
                      child: Text(
                        'Quay lại',
                        style: Style.homesubtitleStyle,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteManager.chatbotScreen);
        },
        backgroundColor: Colors.white24,
        child: SvgPicture.asset(
          'assets/icon_svg/question.svg',
          width: 45, // Kích thước chiều rộng
          height: 45, // Kích thước chiều cao
        ),
      ),
    );
  }
}

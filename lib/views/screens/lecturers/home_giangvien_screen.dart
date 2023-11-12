import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_image/flutter_svg_image.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/models/timeline_lecturers.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';

import '../../../constants/color.dart';
import '../../../constants/currency_formatter.dart';
import '../../../constants/style.dart';
import '../../../controllers/route_manager.dart';
import '../../../services/login_service.dart';

class HomeGiangvienScreen extends StatefulWidget {
  const HomeGiangvienScreen({super.key});

  @override
  State<HomeGiangvienScreen> createState() => _HomeGiangvienScreenState();
}

class _HomeGiangvienScreenState extends State<HomeGiangvienScreen> {
  @override
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  //Lecturers
  String startDateProcessIntern = "Chưa đặt thời gian";
  String endDateProcessIntern = "";
  String startDateLectureEvaluation = "Chưa đặt thời gian";
  String endDateLecturersEvaluation = "";
  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    timeLine();
  }

  void timeLine() {
    FirebaseFirestore.instance
        .collection("ManagementTimeline")
        .doc("giangvien")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            TimelineLecturers timelineLecturers =
                TimelineLecturers.fromJson(data);
            startDateProcessIntern = CurrencyFormatter()
                .formattedDate(timelineLecturers.processIntern!.startDate);
            endDateProcessIntern = CurrencyFormatter()
                .formattedDate(timelineLecturers.processIntern!.endDate);
            startDateLectureEvaluation = CurrencyFormatter()
                .formattedDate(timelineLecturers.evaluationIntern!.startDate);
            endDateLecturersEvaluation = CurrencyFormatter()
                .formattedDate(timelineLecturers.evaluationIntern!.endDate);
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
              const Text('Kiểm tra tiến độ sinh viên'),
              Text(
                '$startDateProcessIntern đến $endDateProcessIntern',
                style: Style.homesubtitleStyle.copyWith(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          content: const Center(
            child: Text(
              'Giảng viên kiểm tra tiến độ thực tập của sinh viên xem có sinh viên nào bị chậm tiến độ hay không thực hiện thực tập hay không.',
            ),
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeCurrentStep >= 1,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Đánh giá kết quả thực tập'),
              Text(
                '$startDateLectureEvaluation đến $endDateLecturersEvaluation',
                style: Style.homesubtitleStyle.copyWith(
                  color: primaryColor,
                ),
              ),
            ],
          ),
          content: const Center(
            child: Text(
              'Sau khi sinh viên đã nộp báo cáo và kết thúc thực tập giảng viên sẽ đánh giá kết quả thực tập cho sinh viên',
            ),
          ),
        ),
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
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Xin chào,',
                        style: Style.subtitleStyle,
                      ),
                      loggedInUser.userName != null
                          ? Text(loggedInUser.userName.toString(),
                              style: Style.titleStyle)
                          : Text(
                              "Đang tải",
                              style: Style.titleStyle,
                            ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  loggedInUser.avatar != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CircleAvatar(
                            radius: 23,
                            child: Image.network(
                              loggedInUser?.avatar.toString() ?? '',
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CircleAvatar(
                            radius: 23,
                            child: Image.asset(
                              'assets/images/user.png',
                            ),
                          ),
                        ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(width: 10),
              //     InkWell(
              //       onTap: () async {
              //         await LoginService().handleGoogleSignOut();
              //         await LoginService().handleSignOut();
              //         await Get.offAllNamed(RouteManager.loginScreen);
              //       },
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: Container(
              //           height: 37,
              //           width: 37,
              //           color: cardsLite,
              //           child: Image(
              //             image: SvgImage.asset(
              //               'assets/icon_svg/Buy.svg',
              //               currentColor: blackColor,
              //             ),
              //             height: 18,
              //             width: 18,
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 15),
              //     InkWell(
              //       onTap: () {
              //         print(user);
              //       },
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: Container(
              //           height: 37,
              //           width: 37,
              //           color: cardsLite,
              //           child: Image(
              //             image: SvgImage.asset(
              //               'assets/icon_svg/Notification.svg',
              //               currentColor: blackColor,
              //             ),
              //             height: 18,
              //             width: 18,
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 20),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: accentColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // GestureDetector(
                      //   onTap: () =>
                      //       Get.toNamed(RouteManager.readStudentCourse),
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     width: 92,
                      //     child: Column(
                      //       children: [
                      //         SvgPicture.asset(
                      //           'assets/icon_svg/searchaddress.svg',
                      //           width: 45, // Kích thước chiều rộng
                      //           height: 45, // Kích thước chiều cao
                      //         ),
                      //         SizedBox(
                      //           height: 40,
                      //           child: Text(
                      //             'Xem thông tin sinh viên',
                      //             style: Style.homesubtitleStyle,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () async {
                          Get.toNamed(RouteManager.readStudentCourse);
                        },
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
                                  'Xem tiến độ thực tập',
                                  style: Style.homesubtitleStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteManager.lecturersEvaluation);
                        },
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
                                'Chấm điểm thực tập',
                                style: Style.homesubtitleStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Quy trình quản lý thực tập giảng viên',
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
        backgroundColor: whiteColor,
        child: SvgPicture.asset(
          'assets/icon_svg/question.svg',
          width: 45, // Kích thước chiều rộng
          height: 45, // Kích thước chiều cao
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
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
    // TODO: implement initState
    fetchData();
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

  List<Step> stepList() => [
        Step(
          state:
              _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 0,
          title: const Text('Đăng ký học phần & Đăng ký công ty'),
          content: const Center(
            child: Text(
                'Sinh viên đăng ký đúng nhóm học phần của lớp mình. Sau khi đăng ký thành công, sinh viên sẽ đăng ký công ty thực tập phù hợp và chờ được xét duyệt.'),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 1,
          title: const Text('Kiểm tra phiếu giao việc & tiếp nhận'),
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
          title: const Text('Thực tập & Nộp báo cáo'),
          content: const Center(
            child: Text(
                'Sau khi thực tập xong, sinh viên sẽ nộp báo cáo cho giảng viên chấm điểm.'),
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeCurrentStep >= 3,
          title: const Text('Hoàn thành'),
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
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteManager.courseRegistrationScreen);
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
                          Get.toNamed(RouteManager.timKiemDiaDiem);
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
            padding: const EdgeInsets.all(20),
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
                        String? idDKHP = await getAllDKHP(loggedInUser.uid!);
                        await Get.toNamed(RouteManager.submitReport,
                            arguments: idDKHP);
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

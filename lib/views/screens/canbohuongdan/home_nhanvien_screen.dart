import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_image/flutter_svg_image.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

import '../../../constants/color.dart';
import '../../../constants/currency_formatter.dart';
import '../../../constants/style.dart';
import '../../../controllers/route_manager.dart';
import '../../../services/login_service.dart';

class HomeNhanVienScreen extends StatefulWidget {
  const HomeNhanVienScreen({super.key});

  @override
  State<HomeNhanVienScreen> createState() => _HomeNhanVienScreenState();
}

class _HomeNhanVienScreenState extends State<HomeNhanVienScreen> {
  @override
  UserModel? loggedInUser = UserModel();
  // User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser!);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  List<Step> stepList() => [
        Step(
          state:
              _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 0,
          title: const Text('Xét duyệt & Lập phiếu tiếp nhận'),
          content: const Center(
            child: Text(
                'Cán bộ sẽ kiểm tra sinh viên đăng ký thực tập, và có thể nhận sinh viên thực tập ở chức năng "Xét duyệt". Sau đó, cán bộ lập phiếu tiếp nhận cho sinh viên. Sau khi lập xong hãy kiểm tra thông tin phiếu ở chức năng "Kiểm tra thông tin phiếu".'),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 1,
          title: const Text('Lập phiếu giao việc'),
          content: const Center(
            child: Text(
              'Cán bộ sẽ tiến hành lập phiếu giao việc chi tiết cho sinh viên ở chức năng "Lập phiếu". Sau khi lập xong hãy kiểm tra thông tin phiếu ở chức năng "Kiểm tra thông tin phiếu".',
            ),
          ),
        ),
        Step(
          state:
              _activeCurrentStep <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 2,
          title: const Text('Đánh giá thực tập'),
          content: const Center(
            child: Text(
                'Sau khi sinh viên hoàn thành quá trình thực tập, cán bộ sẽ nhận xét và đánh giá quá trình thực tập của sinh viên dựa trên phiếu giao việc và chấm điểm vào phiếu đánh giá ở chức năng "Đánh giá thực tập".'),
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeCurrentStep >= 3,
          title: const Text('Hoàn thành'),
          content: const Center(
            child: Text(
              'Chân thành cảm ơn quý cán bộ đã hoàn thành nhiệm vụ trong đợt thực tập này.',
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
                  Text(loggedInUser?.userName.toString() ?? 'Người dùng',
                      style: Style.titleStyle),
                ],
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleAvatar(
                  radius: 23,
                  child: Image.network(loggedInUser?.avatar.toString() ?? ''),
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
                  InkWell(
                    onTap: () {
                      Get.toNamed(RouteManager.duyetThucTap);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 75,
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
                                  'Xét duyệt Lập phiếu',
                                  style: Style.homesubtitleStyle,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Get.toNamed(RouteManager.readAllForm);
                          },
                          child: SizedBox(
                            width: 105,
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
                                    'Kiểm tra thông tin phiếu',
                                    style: Style.homesubtitleStyle,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              RouteManager.internshipEvaluationScreen,
                            );
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
                                    'Đánh giá thực tập',
                                    style: Style.homesubtitleStyle,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Quy trình quản lý thực tập cán bộ',
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
          )),
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

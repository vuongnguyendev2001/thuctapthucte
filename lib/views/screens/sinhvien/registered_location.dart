import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/registration_model.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/tim_kiem_dia_diem/tim_kiem_dia_diem.dart';

import '../../../controllers/route_manager.dart';
import '../../../models/company_intern.dart';

class RegisteredLocationScreen extends StatefulWidget {
  const RegisteredLocationScreen({super.key});

  @override
  State<RegisteredLocationScreen> createState() =>
      _RegisteredLocationScreenState();
}

class _RegisteredLocationScreenState extends State<RegisteredLocationScreen> {
  UserModel loggedInUser = UserModel();
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

  @override
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('registrations').snapshots();
  CollectionReference internshipApplicationsCollection =
      FirebaseFirestore.instance.collection('registrations');
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
        title: const Text('Công ty đã đăng ký'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          List<RegistrationModel> internshipApplications = [];
          for (QueryDocumentSnapshot document in snapshot.data!.docs) {
            String documentId = document.id;
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            RegistrationModel internshipApplication =
                RegistrationModel.fromMap(data);
            internshipApplication.id = documentId;
            internshipApplications.add(internshipApplication);
          }
          Map<String, dynamic> dataToUpdate = {
            'status': 'Đã duyệt',
          };

          return ListView.builder(
            itemCount: internshipApplications.length,
            itemBuilder: ((context, index) {
              if (internshipApplications[index].user.uid == loggedInUser.uid) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        JdCompany(
                            context, internshipApplications[index].Company);
                      },
                      child: Container(
                        color: whiteColor,
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ứng tuyển: ${internshipApplications[index].Company.position}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                internshipApplications[index].Company.name,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Trạng thái: ',
                                  style: Style.subtitleStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          internshipApplications[index].status,
                                      style: internshipApplications[index]
                                                  .status ==
                                              'Đã duyệt'
                                          ? Style.subtitleStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                            )
                                          : Style.subtitleStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: primaryOpacity,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      PdfViewerArguments arguments =
                                          PdfViewerArguments(
                                        internshipApplications[index].urlCV,
                                        internshipApplications[index].nameCV,
                                      );
                                      Get.toNamed(RouteManager.pdfViewer,
                                          arguments: arguments);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: primaryColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye,
                                            color: whiteColor,
                                          ),
                                          Text(
                                            ' Xem CV',
                                            style: TextStyle(color: whiteColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  internshipApplications[index].status ==
                                          'Đã duyệt'
                                      ? InkWell(
                                          onTap: () {
                                            // PdfViewerArguments arguments =
                                            //     PdfViewerArguments(
                                            //   internshipApplications[index]
                                            //       .urlCV,
                                            //   internshipApplications[index]
                                            //       .nameCV,
                                            // );
                                            RegisterViewerArguments arguments =
                                                RegisterViewerArguments(
                                              internshipApplications[index]
                                                  .user,
                                              internshipApplications[index]
                                                  .Company,
                                            );
                                            Get.toNamed(
                                              RouteManager.receiptFormScreen,
                                              arguments: arguments,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: primaryColor,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: whiteColor,
                                                ),
                                                Text(
                                                  ' Lập phiếu tiếp nhận',
                                                  style: TextStyle(
                                                      color: whiteColor),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                                ],
                              )
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
              } else {
                return const SizedBox();
              }
            }),
          );
        },
      ),
    );
  }

  Future<void> JdCompany(BuildContext context, CompanyIntern companies) {
    return showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                color: background,
                height: Get.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companies.position,
                              style: Style.titleStyle,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  child: Image.network(
                                    companies.logo,
                                    height: 55,
                                    width: 55,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  companies.name.toUpperCase(),
                                  style: Style.titlegreyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vị trí thực tập: ', style: Style.titleStyle),
                            Text(
                              companies.companyDetail.internshipPosition,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Thời gian thực tập: ',
                                style: Style.titleStyle),
                            Text(
                              companies.companyDetail.internshipDuration,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quyền lợi: ', style: Style.titleStyle),
                            Text(
                              companies.companyDetail.benefits,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Địa điểm thực tập: ',
                                style: Style.titleStyle),
                            Text(
                              companies.companyDetail.address,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nhận hồ sơ: ', style: Style.titleStyle),
                            Text(
                              companies.companyDetail.applicationMethod,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
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
                              // RegisterCompany(context);
                              // Get.toNamed(RouteManager.dangkythuctap);
                              RegisterViewerArguments arguments =
                                  RegisterViewerArguments(
                                loggedInUser,
                                companies,
                              );

                              bool? registed = await getAllApplications(
                                  loggedInUser.uid!, companies.id);
                              if (registed == false) {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return RegisterCompanyScreen(
                                        arguments: arguments,
                                      );
                                    });
                              } else {
                                EasyLoading.showError('Bạn đã ứng tuyển rồi!');
                              }
                            },
                            // onPressed: () async {

                            // },
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
                                  'Đăng ký thực tập',
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
          ],
        );
      },
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/course_register.dart';
import 'package:trungtamgiasu/models/hoc_phan.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';

class QuanLyHocPhan extends StatefulWidget {
  const QuanLyHocPhan({super.key});

  @override
  State<QuanLyHocPhan> createState() => _QuanLyHocPhanState();
}

class _QuanLyHocPhanState extends State<QuanLyHocPhan> {
  String? selectedSemester;
  String? selectedAcademicYear;
  Future<void> addDataToFirestore() async {
    CollectionReference courseRegistrationsCollection =
        FirebaseFirestore.instance.collection('HocKi');
    try {
      for (var jsonCourse in jsonCourseRegistrationData) {
        courseRegistrationsCollection.add(jsonCourse).then((documentReference) {
          String documentId = documentReference.id;
          documentReference.update({'id': documentId}).then((_) {
            print('ID của tài liệu vừa được thêm và cập nhật: $documentId');
          }).catchError((error) {
            print('Lỗi khi cập nhật ID của tài liệu: $error');
          });
        }).catchError((error) {
          print('Lỗi khi thêm tài liệu: $error');
        });
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Quản lý học phần',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
        actions: [
          InkWell(
            onTap: () async {
              await addDataToFirestore();
            },
            child: CircleAvatar(
              backgroundColor: whiteColor,
              radius: 17,
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('HocKi').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('Không có dữ liệu.');
          } else {
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            List<CourseRegistration> courseRegistrations = [];

            for (QueryDocumentSnapshot doc in documents) {
              String idDocument = doc.id;
              Map<String, dynamic> jsonData =
                  doc.data() as Map<String, dynamic>;
              CourseRegistration courseRegistration =
                  CourseRegistration.fromMap(jsonData);
              courseRegistration.id = idDocument;
              courseRegistrations.add(courseRegistration);
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
            selectedAcademicYear ??= uniqueAcademicYears.isNotEmpty
                ? uniqueAcademicYears.first
                : null;
            return Column(
              children: [
                // const SizedBox(height: 10),
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
                            setState(() {
                              selectedSemester = newValue;
                            });
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
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: courseRegistrations.length,
                      itemBuilder: (context, index) {
                        CourseRegistration courseRegistration =
                            courseRegistrations[index];

                        // Kiểm tra xem học kỳ và năm học có trùng với học kỳ và năm học đã chọn không
                        if (courseRegistration.semester == selectedSemester &&
                            courseRegistration.academicYear ==
                                selectedAcademicYear) {
                          print(courseRegistration.id);
                          // return InkWell(
                          //   onTap: () async {
                          //     try {
                          //       CollectionReference
                          //           courseRegistrationsCollection =
                          //           FirebaseFirestore.instance
                          //               .collection('HocKi')
                          //               .doc(courseRegistration.id)
                          //               .collection('AllHocPhan');
                          //       for (var data in jsonHocPhanData) {
                          //         courseRegistrationsCollection
                          //             .add(data)
                          //             .then((documentReference) {
                          //           String documentId = documentReference.id;
                          //           // Cập nhật trường ID của tài liệu với ID vừa lấy được
                          //           documentReference.update({
                          //             'id': documentId,
                          //             'idHocki': courseRegistration.id,
                          //           }).then((_) {
                          //             // In ID của tài liệu sau khi đã cập nhật
                          //             print(
                          //                 'ID của tài liệu vừa được thêm và cập nhật: $documentId');
                          //           }).catchError((error) {
                          //             // Xử lý lỗi nếu có khi cập nhật
                          //             print(
                          //                 'Lỗi khi cập nhật ID của tài liệu: $error');
                          //           });
                          //         }).catchError((error) {
                          //           // Xử lý lỗi nếu có khi thêm tài liệu
                          //           print('Lỗi khi thêm tài liệu: $error');
                          //         });
                          //       }

                          //       print(
                          //           'Dữ liệu đã được thêm vào Firestore thành công.');
                          //     } catch (e) {
                          //       print('Lỗi: $e');
                          //     }
                          //   },
                          //   child: CircleAvatar(
                          //     backgroundColor: blackColor,
                          //     radius: 17,
                          //     child: const Icon(Icons.add),
                          //   ),
                          // );
                          return SingleChildScrollView(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('HocKi')
                                  .doc(courseRegistration.id)
                                  .collection('AllHocPhan')
                                  .orderBy('maHocPhan')
                                  // .orderBy('kyHieu')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ));
                                } else if (snapshot.hasError) {
                                  return Text('Lỗi: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Expanded(
                                    child: SizedBox(
                                      height: Get.height * 0.85,
                                      child: Image.asset(
                                        'assets/images/nodata.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                } else {
                                  List<QueryDocumentSnapshot> documents =
                                      snapshot.data!.docs;
                                  List<HocPhan> AllhocPhan = [];

                                  for (QueryDocumentSnapshot doc in documents) {
                                    String idDocument = doc.id;
                                    Map<String, dynamic> jsonData =
                                        doc.data() as Map<String, dynamic>;
                                    HocPhan hocPhan = HocPhan.fromMap(jsonData);
                                    hocPhan.id = idDocument;
                                    AllhocPhan.add(hocPhan);
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: AllhocPhan.length,
                                    itemBuilder: (context, index) {
                                      HocPhan hocPhan = AllhocPhan[index];
                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(hocPhan.tenHocPhan),
                                                InkWell(
                                                  onTap: () async {
                                                    SinhVienDaDangKyThucTapArguments
                                                        arguments =
                                                        SinhVienDaDangKyThucTapArguments(
                                                            courseRegistration
                                                                .id!,
                                                            hocPhan.id!);
                                                    Get.toNamed(
                                                        RouteManager.svDaDKHP,
                                                        arguments: arguments);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      color: primaryColor,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .supervised_user_circle_rounded,
                                                          color: whiteColor,
                                                        ),
                                                        Text(
                                                          'Danh sách SV',
                                                          style: TextStyle(
                                                            color: whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            subtitle: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Mã HP'),
                                                    Text(hocPhan.maHocPhan),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Ký hiệu'),
                                                    Text(hocPhan.kyHieu),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Lớp'),
                                                    Text(hocPhan.lop),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        'Cán bộ giảng dạy'),
                                                    Text(hocPhan.giaoVien),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          return Container(); // Không hiển thị nếu không trùng
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

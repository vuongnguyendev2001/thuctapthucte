import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/course_register.dart';
import 'package:trungtamgiasu/models/hoc_phan.dart';

class LearningOutcomes extends StatefulWidget {
  const LearningOutcomes({super.key});
  @override
  State<LearningOutcomes> createState() => _LearningOutcomesState();
}

class _LearningOutcomesState extends State<LearningOutcomes> {
  CollectionReference DKHPData =
      FirebaseFirestore.instance.collection('DangKyHocPhan');
  CollectionReference hocKyData =
      FirebaseFirestore.instance.collection('HocKi');
  String? idDKHP;
  @override
  initState() {
    super.initState();
    idDKHP = Get.arguments;
  }

  String? selectedSemester;
  String? selectedAcademicYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Kết quả học tập',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('HocKi').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
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

            List<String?> idHK = courseRegistrations
                .map((courseRegistration) => courseRegistration.id)
                .toSet()
                .toList();
            print(idHK);
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
                            setState(
                              () {
                                selectedSemester = newValue;
                              },
                            );
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
                  child: ListView.builder(
                    itemCount: courseRegistrations.length,
                    itemBuilder: (context, index) {
                      CourseRegistration courseRegistration =
                          courseRegistrations[index];
                      if (courseRegistration.semester == selectedSemester &&
                          courseRegistration.academicYear ==
                              selectedAcademicYear) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: DKHPData.doc(idDKHP).get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            }
                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return Center(
                                child: Text(
                                  'Bạn chưa đăng ký học phần !',
                                  style: Style.titleStyle,
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              DangKyHocPhan dkhp = DangKyHocPhan.fromMap(data);
                              String? totalScore;
                              String? totalScoreWord;
                              if (dkhp.lecturersEvaluation == null) {
                                totalScore = '-';
                                totalScoreWord = '';
                              } else {
                                totalScore =
                                    dkhp.lecturersEvaluation!.totalScore;
                                totalScoreWord =
                                    dkhp.lecturersEvaluation!.total;
                              }
                              if (courseRegistrations[index].id == dkhp.idHK) {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: hocKyData
                                      .doc(dkhp.idHK)
                                      .collection('AllHocPhan')
                                      .doc(dkhp.idHP)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text("Something went wrong");
                                    }
                                    if (snapshot.hasData &&
                                        !snapshot.data!.exists) {
                                      return Center(
                                        child: Text(
                                          'Bạn chưa đăng ký học phần !',
                                          style: Style.titleStyle,
                                        ),
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      Map<String, dynamic> data = snapshot.data!
                                          .data() as Map<String, dynamic>;
                                      HocPhan learningOutcomes =
                                          HocPhan.fromMap(data);
                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(learningOutcomes
                                                    .tenHocPhan),
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
                                                    Text(learningOutcomes
                                                        .maHocPhan),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Ký hiệu'),
                                                    Text(learningOutcomes
                                                        .kyHieu),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Lớp'),
                                                    Text(learningOutcomes.lop),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        'Cán bộ giảng dạy'),
                                                    Text(learningOutcomes
                                                        .giaoVien),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Điểm'),
                                                    Text(
                                                      '${totalScore!} ${totalScoreWord!}',
                                                      style: Style.subtitleStyle
                                                          .copyWith(
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                        ],
                                      );
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Text('Không có dữ liệu');
                              }
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            );
                          },
                        );
                      }
                      return null;
                    },
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

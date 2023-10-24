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
      body: FutureBuilder<DocumentSnapshot>(
        future: DKHPData.doc(idDKHP).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return SizedBox(
              height: Get.height * 0.85,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/nodata.jpg',
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Bạn chưa đăng ký học phần !',
                    style: Style.titleStyle,
                  )
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            DangKyHocPhan dkhp = DangKyHocPhan.fromMap(data);
            String? totalScore;
            String? totalScoreWord;
            if (dkhp.lecturersEvaluation == null) {
              totalScore = '-';
              totalScoreWord = '';
            } else {
              totalScore = dkhp.lecturersEvaluation!.totalScore;
              totalScoreWord = dkhp.lecturersEvaluation!.total;
            }
            return FutureBuilder<DocumentSnapshot>(
              future: hocKyData
                  .doc(dkhp.idHK)
                  .collection('AllHocPhan')
                  .doc(dkhp.idHP)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return SizedBox(
                    height: Get.height * 0.85,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/nodata.jpg',
                          fit: BoxFit.cover,
                        ),
                        Text(
                          'Bạn chưa đăng ký học phần !',
                          style: Style.titleStyle,
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  HocPhan learningOutcomes = HocPhan.fromMap(data);
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(learningOutcomes.tenHocPhan),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Mã HP'),
                                Text(learningOutcomes.maHocPhan),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Ký hiệu'),
                                Text(learningOutcomes.kyHieu),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Lớp'),
                                Text(learningOutcomes.lop),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Cán bộ giảng dạy'),
                                Text(learningOutcomes.giaoVien),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Điểm'),
                                Text(
                                  '${totalScore!} ${totalScoreWord!}',
                                  style: Style.subtitleStyle.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
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
                  ;
                }

                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
          
        },
      ),
    );
  }
}

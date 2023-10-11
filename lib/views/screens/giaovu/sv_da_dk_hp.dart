import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';

class SVDADKHP extends StatefulWidget {
  const SVDADKHP({super.key});

  @override
  State<SVDADKHP> createState() => _SVDADKHPState();
}

class _SVDADKHPState extends State<SVDADKHP> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SinhVienDaDangKyThucTapArguments? arguments =
        Get.arguments as SinhVienDaDangKyThucTapArguments?;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Danh Sách Sinh Viên',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('DangKyHocPhan').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            List<DangKyHocPhan> DKHPList = [];
            
            for (QueryDocumentSnapshot doc in documents) {
              Map<String, dynamic> jsonData =
                  doc.data() as Map<String, dynamic>;
              DangKyHocPhan DKHP = DangKyHocPhan.fromMap(jsonData);
              DKHPList.add(DKHP);
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: DKHPList.length,
              itemBuilder: (context, index) {
                DangKyHocPhan dangKyHocPhan = DKHPList[index];
                if (dangKyHocPhan.idHK == arguments!.idHocKiNamHoc &&
                    dangKyHocPhan.idHP == arguments.idAllHocPhan) {
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dangKyHocPhan.user.MSSV!),
                            // InkWell(
                            //   onTap: () async {},
                            //   child: Container(
                            //     padding: const EdgeInsets.all(3),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(7),
                            //       color: primaryColor,
                            //     ),
                            //     child: Row(
                            //       children: [
                            //         Icon(
                            //           Icons.supervised_user_circle_rounded,
                            //           color: whiteColor,
                            //         ),
                            //         Text(
                            //           'Danh sách SV',
                            //           style: TextStyle(
                            //             color: whiteColor,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Họ Tên'),
                                Text(dangKyHocPhan.user.userName!),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Gmail'),
                                Text(dangKyHocPhan.user.email!),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Lớp'),
                                Text(dangKyHocPhan.user.idClass!),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Địa chỉ'),
                                Text(dangKyHocPhan.user.address!),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }
}

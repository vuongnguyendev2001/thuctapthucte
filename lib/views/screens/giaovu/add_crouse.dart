import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/hoc_phan.dart';
import 'package:trungtamgiasu/views/screens/mentor/receipt_form_screen.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final TextEditingController idCourse = TextEditingController();
  final TextEditingController nameCourse = TextEditingController();
  final TextEditingController classCourse = TextEditingController();
  final TextEditingController symbolCourse = TextEditingController();
  final List<String> nameLectures = [
    "Nguyễn Thái Nghe",
    "Phạm Thị Ngọc Diễm",
    "Nguyễn Thanh Hải",
    "Phạm Xuân Hiền",
    "Phạm Nguyên Hoàng",
    "Trần Việt Châu",
    "Thái Minh Tuấn",
    "Trần Minh Tân",
  ];
  String nameLecture = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Thêm học phần',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormReceipt(
                lableText: 'Mã học phần', controller: idCourse, icon: null),
            const SizedBox(
              height: 15,
            ),
            TextFormReceipt(
                lableText: 'Tên học phần', controller: nameCourse, icon: null),
            const SizedBox(
              height: 15,
            ),
            TextFormReceipt(
                lableText: 'Lớp học phần', controller: classCourse, icon: null),
            const SizedBox(
              height: 15,
            ),
            TextFormReceipt(
                lableText: 'Ký hiệu', controller: symbolCourse, icon: null),
            const SizedBox(
              height: 15,
            ),
            DropdownMenu<String>(
              width: Get.width * 0.95,
              label: const Text('Giảng viên'),
              leadingIcon: const Icon(Icons.person),
              textStyle: Style.subtitleStyle,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  nameLecture = value!;
                  print(nameLecture);
                });
              },
              dropdownMenuEntries:
                  nameLectures.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                HocPhan hocPhan = HocPhan(
                  "",
                  "1FJ5FbLAFTGWp9BLMQw1",
                  idCourse.text,
                  nameCourse.text,
                  classCourse.text,
                  nameLecture,
                  "",
                  symbolCourse.text,
                );
                if (nameLecture != "" && idCourse.text != "") {
                  FirebaseFirestore.instance
                      .collection("HocKi")
                      .doc('1FJ5FbLAFTGWp9BLMQw1')
                      .collection("AllHocPhan")
                      .add(hocPhan.toMap())
                      .then((document) {
                    String documentId = document.id;
                    document.update({
                      "id": documentId,
                    }).then((_) {
                      EasyLoading.showSuccess("Thêm thành công !");
                      Get.back();
                    });
                  });
                } else {
                  EasyLoading.showError("Thiếu dữ liệu");
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  color: primaryColor,
                  height: 50,
                  width: double.infinity,
                  child: Text(
                    'Thêm học phần',
                    style: Style.homeTitleStyle,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

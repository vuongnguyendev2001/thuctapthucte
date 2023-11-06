import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/receipt_form_screen.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
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
                lableText: 'Mã học phần', controller: null, icon: null),
            const SizedBox(
              height: 15,
            ),
            TextFormReceipt(
                lableText: 'Tên học phần', controller: null, icon: null),
            const SizedBox(
              height: 15,
            ),
            TextFormReceipt(
                lableText: 'Lớp học phần', controller: null, icon: null),
            const SizedBox(
              height: 15,
            ),
            TextFormReceipt(lableText: 'Ký hiệu', controller: null, icon: null),
            const SizedBox(
              height: 15,
            ),
            TextFormReceipt(
                lableText: 'Giáo viên', controller: null, icon: null),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {},
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

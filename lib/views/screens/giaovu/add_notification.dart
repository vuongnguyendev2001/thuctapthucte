import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/notification.dart';
import 'package:trungtamgiasu/services/firebase_api.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/receipt_form_screen.dart';

class AddNotification extends StatefulWidget {
  const AddNotification({super.key});

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  final TextEditingController title = TextEditingController();
  final TextEditingController body = TextEditingController();
  final TextEditingController topic = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        title: Text(
          'Thêm thông báo'.toUpperCase(),
          style: Style.homeTitleStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 15),
            TextFormReceipt(
                lableText: 'Nội dung', controller: title, icon: null),
            const SizedBox(height: 15),
            TextFormReceipt(
                lableText: 'Chi tiết', controller: body, icon: null),
            const SizedBox(height: 15),
            TextFormReceipt(lableText: 'Chủ đề', controller: topic, icon: null),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                await FirebaseApi().sendFirebaseCloudMessageToTopic(
                  title.text,
                  body.text,
                  topic.text,
                );
                Notifications notifications = Notifications(
                  title: title.text,
                  body: body.text,
                  timestamp: Timestamp.now(),
                  emailUser: '',
                );
                await FirebaseFirestore.instance
                    .collection('notifications')
                    .add(
                      notifications.toJson(),
                    );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  color: primaryColor,
                  height: 50,
                  width: double.infinity,
                  child: Text(
                    'Đăng thông báo',
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

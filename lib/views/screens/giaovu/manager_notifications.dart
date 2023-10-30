import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';

class ManagerNotification extends StatefulWidget {
  const ManagerNotification({super.key});

  @override
  State<ManagerNotification> createState() => _ManagerNotificationState();
}

class _ManagerNotificationState extends State<ManagerNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        title: Text(
          'Quản lý thông báo'.toUpperCase(),
          style: Style.homeTitleStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          InkWell(
            onTap: () async {
              Get.toNamed(RouteManager.addNotification);
            },
            child: CircleAvatar(
              backgroundColor: whiteColor,
              radius: 17,
              child: const Icon(Icons.add_outlined),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}

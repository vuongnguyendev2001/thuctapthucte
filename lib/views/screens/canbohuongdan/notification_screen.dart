import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotificationScreenCanBo extends StatefulWidget {
  const NotificationScreenCanBo({super.key});

  @override
  State<NotificationScreenCanBo> createState() =>
      _NotificationScreenCanBoState();
}

class _NotificationScreenCanBoState extends State<NotificationScreenCanBo> {
  @override
  Widget build(BuildContext context) {
    // final message = Get.arguments as RemoteMessage;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Text('${message.notification?.title}'),
            // Text('${message.notification?.body}'),
            // Text('${message.data}'),
          ],
        ),
      ),
    );
  }
}

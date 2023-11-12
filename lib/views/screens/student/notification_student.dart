import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';

class NotificationStudent extends StatefulWidget {
  const NotificationStudent({super.key});

  @override
  State<NotificationStudent> createState() => _NotificationStudentState();
}

class _NotificationStudentState extends State<NotificationStudent> {
  RemoteMessage? message;
  @override
  initState() {
    super.initState();
    message = Get.arguments as RemoteMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
        title: Text(
          'Thông báo',
          style: Style.hometitleStyle.copyWith(color: whiteColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: whiteColor,
              ),
              child: ListTile(
                title: Text(
                  '${message?.notification!.title}',
                  style: Style.titleStyle,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${message?.notification!.body}',
                      style: Style.subtitleStyle,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    message?.data['urlFile'] != null
                        ? InkWell(
                            onTap: () {
                              PdfViewerArguments arguments = PdfViewerArguments(
                                message?.data['urlFile'],
                                message?.data['filename'],
                              );
                              Get.toNamed(
                                RouteManager.pdfViewer,
                                arguments: arguments,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              width: 90,
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
                                    ' Xem file',
                                    style: TextStyle(color: whiteColor),
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        message?.data['timestamp'],
                        style: Style.subtitleStyle.copyWith(
                          fontSize: 10,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_right_outlined,
                  color: primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

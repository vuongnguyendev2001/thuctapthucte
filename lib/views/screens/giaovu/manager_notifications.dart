import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/notification.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';

class ManagerNotification extends StatefulWidget {
  const ManagerNotification({super.key});

  @override
  State<ManagerNotification> createState() => _ManagerNotificationState();
}

class _ManagerNotificationState extends State<ManagerNotification> {
  final Stream<QuerySnapshot> notificationsStream = FirebaseFirestore.instance
      .collection('notifications')
      .orderBy(
        'timestamp',
        descending: true,
      )
      .snapshots();
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
      body: StreamBuilder<QuerySnapshot>(
        stream: notificationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Không có thông báo',
                  style: Style.titleStyle,
                ),
              ),
            );
          }
          List<Widget> notificationWidgets =
              snapshot.data!.docs.where((document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            Notifications notifications = Notifications.fromJson(data);
            return notifications.emailUser == '';
          }).map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            Notifications notifications = Notifications.fromJson(data);
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: whiteColor,
                ),
                child: ListTile(
                  leading: InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('notifications')
                          .doc(notifications.id)
                          .delete()
                          .then(
                        (_) {
                          EasyLoading.showSuccess(
                            'Xóa thành công',
                          );
                        },
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: greyFontColor,
                      child: Icon(
                        Icons.delete_outline_outlined,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  title: Text(
                    notifications.title,
                    style: Style.titleStyle,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notifications.body,
                        style: Style.subtitleStyle,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      notifications.urlFile != null
                          ? InkWell(
                              onTap: () {
                                PdfViewerArguments arguments =
                                    PdfViewerArguments(
                                  notifications.urlFile!,
                                  notifications.nameFile!,
                                );
                                Get.toNamed(RouteManager.pdfViewer,
                                    arguments: arguments);
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
                          CurrencyFormatter()
                              .formattedDatebook(notifications.timestamp),
                          style: Style.subtitleStyle.copyWith(
                            fontSize: 10,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_right_outlined,
                    color: primaryColor,
                  ),
                ),
              ),
            );
          }).toList();

          if (notificationWidgets.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Không có thông báo',
                  style: Style.titleStyle,
                ),
              ),
            );
          } else {
            return ListView(
              children: notificationWidgets,
            );
          }
        },
      ),
    );
  }
}

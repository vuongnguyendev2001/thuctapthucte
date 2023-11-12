import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/notification.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/services/firebase_api.dart';
import 'package:trungtamgiasu/views/screens/mentor/receipt_form_screen.dart';

class AddNotification extends StatefulWidget {
  const AddNotification({super.key});

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  final TextEditingController title = TextEditingController();
  final TextEditingController body = TextEditingController();
  final TextEditingController topic = TextEditingController();

  Future<String?> uploadPdf(String fileName, File file) async {
    final refrence = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = refrence.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await refrence.getDownloadURL();
    return downloadLink;
  }

  String? pdfUrl;
  String? fileNamePdf = 'Tải lên file đính kèm định dạng .pdf';
  Future<void> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      var downloadLink = await uploadPdf(fileName, file);
      setState(() {
        pdfUrl = downloadLink;
        fileNamePdf = fileName;
      });
      print("pdf uploaded successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: primaryColor,
        title: Text(
          'Đăng thông báo'.toUpperCase(),
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
              lableText: 'Nội dung',
              controller: title,
              icon: const Icon(
                Icons.abc_outlined,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            TextFormReceipt(
              lableText: 'Nội dung chi tiết',
              controller: body,
              icon: const Icon(
                Icons.abc_outlined,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () async {
                try {
                  await Loading().isShowLoading();
                  await pickFile();
                } catch (e) {
                  print(e);
                } finally {
                  await Loading().isOffShowLoading();
                }
              },
              child: Container(
                color: textBoxLite,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          color: whiteColor,
                          child: Text(
                            fileNamePdf!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        child: Icon(
                          Icons.upload_file,
                          color: whiteColor,
                        ),
                        backgroundColor: primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            pdfUrl != null
                ? InkWell(
                    onTap: () {
                      PdfViewerArguments arguments = PdfViewerArguments(
                        pdfUrl!,
                        fileNamePdf!,
                      );
                      Get.toNamed(RouteManager.pdfViewer, arguments: arguments);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 100,
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
            const SizedBox(height: 15),
            InkWell(
              onTap: () async {
                try {
                  PdfViewerArguments pdfViewer = PdfViewerArguments(
                    pdfUrl!,
                    fileNamePdf!,
                  );
                  await FirebaseApi().sendFirebaseCloudMessageToTopic(
                    title.text,
                    body.text,
                    'all',
                    pdfUrl ?? '',
                    fileNamePdf ?? '',
                  );
                  Notifications notifications = Notifications(
                    title: title.text,
                    body: body.text,
                    timestamp: Timestamp.now(),
                    emailUser: '',
                    urlFile: pdfUrl,
                    nameFile: fileNamePdf,
                  );
                  await FirebaseFirestore.instance
                      .collection('notifications')
                      .add(
                        notifications.toJson(),
                      )
                      .then(
                    (documentReference) {
                      String documentId = documentReference.id;
                      documentReference.update({
                        'id': documentId,
                      }).then(
                        (_) {
                          Loading().isShowSuccess('Đăng thông báo thành công');
                          Get.back();
                        },
                      );
                    },
                  );
                } catch (e) {
                  print(e);
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

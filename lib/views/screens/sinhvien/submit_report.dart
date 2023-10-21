import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/enums/snack_bar_type.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/constants/ui_helper.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';

class SubmitReport extends StatefulWidget {
  const SubmitReport({super.key});

  @override
  State<SubmitReport> createState() => _SubmitReportState();
}

class _SubmitReportState extends State<SubmitReport> {
  String? pdfUrl;
  String? fileNamePdf = 'Tải lên file báo cáo định dạng .pdf';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String?> uploadPdf(String fileName, File file) async {
    final refrence =
        FirebaseStorage.instance.ref().child("submitReport/$fileName.pdf");
    final uploadTask = refrence.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await refrence.getDownloadURL();
    return downloadLink;
  }

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
      print("submit report file uploaded successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Nộp báo cáo thực tập'.toUpperCase(),
          style: Style.homeStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text('Hồ sơ của bạn'.toUpperCase(),
            //     style: Style.hometitleStyle.copyWith(color: primaryColor)),
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
                width: Get.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Text(
                          fileNamePdf!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.upload_file,
                        color: whiteColor,
                        size: 40,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                      padding: const EdgeInsets.all(10),
                      width: Get.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            color: whiteColor,
                          ),
                          Text(
                            ' Xem lại báo cáo đã tải lên',
                            style: TextStyle(color: whiteColor),
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await Loading().isShowLoading();
                                if (pdfUrl == null) {
                                  UIHelper.showFlushbar(
                                    message: 'Bạn chưa tải lên file báo cáo',
                                    snackBarType: SnackBarType.error,
                                  );
                                } else {
                                  // await add_register(
                                  //     loggedInUser, companyIntern!);
                                  // await FirebaseApi()
                                  //     .sendFirebaseCloudMessage();
                                }
                              } catch (e) {
                                print(e);
                              } finally {
                                await Loading().isOffShowLoading();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width, 44),
                              elevation: 0.0,
                              backgroundColor: primaryColor,
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: backgroundLite,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Nộp báo cáo',
                                  // 'login'.tr.capitalize,
                                  style: Style.titleStyle.copyWith(
                                      color: backgroundLite, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 5),
            // const Text(
            //     'Kiểm tra thông tin ứng tuyển ở danh sách địa điểm đăng ký')
          ],
        ),
      ),
    );
  }
}

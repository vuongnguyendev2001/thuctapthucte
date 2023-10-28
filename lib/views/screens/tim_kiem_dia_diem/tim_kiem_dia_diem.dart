import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/enums/snack_bar_type.dart';
import 'package:trungtamgiasu/constants/loading.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/constants/ui_helper.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/notification.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/registration_model.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/firebase_api.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/receipt_form_screen.dart';

class TimKiemDiaDiem extends StatefulWidget {
  const TimKiemDiaDiem({super.key});

  @override
  State<TimKiemDiaDiem> createState() => _TimKiemDiaDiemState();
}

class _TimKiemDiaDiemState extends State<TimKiemDiaDiem> {
  @override
  UserModel loggedInUser = UserModel();
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  final TextEditingController _search = TextEditingController();

  void addCompaniesToFirestore(List<CompanyIntern> companies) async {
    CollectionReference companyCollection =
        FirebaseFirestore.instance.collection('companies');
    for (var company in companies) {
      Map<String, dynamic> companyData = company.toMap();
      await companyCollection.add(companyData);
    }
  }

  void search(String keyword) {
    companies.clear();
    for (CompanyIntern company in companies) {
      if (company.name.toLowerCase().contains(keyword.toLowerCase()) ||
          company.location.toLowerCase().contains(keyword.toLowerCase())) {
        companies.add(company);
      }
    }
    setState(() {});
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String?> uploadPdf(String fileName, File file) async {
    final refrence = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = refrence.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await refrence.getDownloadURL();
    return downloadLink;
  }

  String? pdfUrl;
  String? fileNamePdf = 'Vui lòng tải lên file .pdf';
  void pickFile() async {
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

  Future<String?> get_regiter(String? idRegister) async {
    final userDoc =
        FirebaseFirestore.instance.collection('registrations').doc(idRegister);
    final id = await userDoc.get();
    if (id.exists) {
      final idDoc = id.data()?['id'];
      print(idDoc);
      return idDoc;
    }
  }

  Future<UserModel?> get_userCanbo(String? idCompany) async {
    UserModel? user = UserModel();
    final userDoc =
        FirebaseFirestore.instance.collection('user').doc(idCompany);
    final userCanBo = await userDoc.get();
    if (userCanBo.exists) {
      final user = userCanBo as UserModel;
      print(user);
      return user;
    }
  }

  CollectionReference internshipApplicationsCollection =
      FirebaseFirestore.instance.collection('registrations');

  Future<bool?> getAllApplications(String userID, String companyID) async {
    QuerySnapshot querySnapshot = await internshipApplicationsCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        RegistrationModel internshipApplication =
            RegistrationModel.fromMap(data);
        if (internshipApplication.user.uid == userID &&
            internshipApplication.Company.id == companyID) {
          return true;
        }
      }
    }
    return false;
  }

  Future<List<CompanyIntern>> getCompanies() async {
    QuerySnapshot companiesSnapshot =
        await FirebaseFirestore.instance.collection('companies').get();
    List<CompanyIntern> companies = [];
    companiesSnapshot.docs.forEach((orderDoc) {
      CompanyIntern company =
          CompanyIntern.fromMap(orderDoc.data() as Map<String, dynamic>);
      companies.add(company);
    });
    return companies;
  }

  Future<UserModel?> getUserForCompany(CompanyIntern company) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(company.idUserCanBo)
        .get();
    if (userSnapshot.exists) {
      UserModel user =
          UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      print(user.userName);
      return user;
    } else {
      print('null');
      return null; // Không tìm thấy người dùng tương ứng.
    }
  }

  // Future<void> fetchOrdersWithUsers() async {
  //   List<CompanyIntern> companies = await getCompanies();

  //   for (CompanyIntern company in companies) {
  //     UserModel? user = await getUserForCompany(company);
  //     if (user != null) {
  //       // Bây giờ bạn có thể làm bất cứ điều gì với thông tin đơn hàng và thông tin người dùng đã được kết hợp lại.
  //       print('Order ID: ${user.uid}, User Name: ${user.userName}');
  //     }
  //   }
  // }
  var searchPosition = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Danh sách địa điểm thực tập',
          style: Style.homeTitleStyle,
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       addCompaniesToFirestore(companies);
        //     },
        //     icon: const Icon(
        //       Icons.add_circle_outline_outlined,
        //     ),
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              height: 45,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: whiteColor,
              ),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    searchPosition = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Vị trí tuyển dụng, công nghệ, ngôn ngữ,...',
                  prefixIcon: Icon(Icons.search_outlined),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("companies")
                    .orderBy('name')
                    // .where('position', isGreaterThan: searchPosition)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Dữ liệu đã tải thành công từ Firestore
                    List<CompanyIntern> companies = [];
                    for (QueryDocumentSnapshot document
                        in snapshot.data!.docs) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      CompanyIntern company = CompanyIntern.fromMap(data);

                      if (company.position
                          .toLowerCase()
                          .contains(searchPosition.toLowerCase())) {
                        companies.add(company);
                      }
                    }
                    // Hiển thị danh sách công ty bằng ListView.builder
                    return ListView.builder(
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                JdCompany(context, companies, index);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  border: Border.all(
                                    color: textBoxLite,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    companies[index].logo != null
                                        ? SizedBox(
                                            child: Image.network(
                                              companies[index].logo,
                                              height: 55,
                                              width: 55,
                                            ),
                                          )
                                        : SizedBox(
                                            child: Image.asset(
                                              'assets/loading.jpg',
                                              height: 55,
                                              width: 55,
                                            ),
                                          ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            companies[index].position,
                                            style: Style.titleStyle
                                                .copyWith(fontSize: 14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            companies[index].name.toUpperCase(),
                                            style: Style.titlegreyStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.attach_money_outlined,
                                                color: primaryColor,
                                                size: 20,
                                              ),
                                              Text(
                                                companies[index].salary > 1
                                                    ? CurrencyFormatter
                                                        .convertPrice(
                                                            price:
                                                                companies[index]
                                                                    .salary)
                                                    : 'Thỏa thuận',
                                                style: Style.priceStyle,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_city_outlined,
                                                color: primaryColor,
                                                size: 20,
                                              ),
                                              Text(
                                                companies[index].location,
                                                style: Style.titlegreyStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                        // Hiển thị các thông tin khác của công ty
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    // Xử lý lỗi
                    return Center(
                      child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
                    );
                  } else {
                    // Dữ liệu đang tải, hiển thị tiêu đề tạm thời
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> JdCompany(
      BuildContext context, List<CompanyIntern> companies, int index) {
    return showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                color: background,
                height: Get.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companies[index].position,
                              style: Style.titleStyle,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  child: Image.network(
                                    companies[index].logo,
                                    height: 55,
                                    width: 55,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  companies[index].name.toUpperCase(),
                                  style: Style.titlegreyStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vị trí thực tập: ', style: Style.titleStyle),
                            Text(
                              companies[index].companyDetail.internshipPosition,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Thời gian thực tập: ',
                                style: Style.titleStyle),
                            Text(
                              companies[index].companyDetail.internshipDuration,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quyền lợi: ', style: Style.titleStyle),
                            Text(
                              companies[index].companyDetail.benefits,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Địa điểm thực tập: ',
                                style: Style.titleStyle),
                            Text(
                              companies[index].companyDetail.address,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(10),
                        color: whiteColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nhận hồ sơ: ', style: Style.titleStyle),
                            Text(
                              companies[index].companyDetail.applicationMethod,
                              style: Style.subtitleStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: Get.width,
              height: 55,
              color: greyFontColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 50,
                    width: Get.width * 0.7,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              RegisterViewerArguments arguments =
                                  RegisterViewerArguments(
                                loggedInUser,
                                companies[index],
                              );
                              bool? registed = await getAllApplications(
                                  loggedInUser.uid!, companies[index].id);
                              if (registed == false) {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return RegisterCompanyScreen(
                                        arguments: arguments,
                                      );
                                    });
                              } else {
                                EasyLoading.showError('Bạn đã ứng tuyển rồi!');
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
                                  'Đăng ký thực tập',
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
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                      radius: 20,
                      backgroundColor: whiteColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> RegisterCompany(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Đính kèm CV'),
                  Row(
                    children: [
                      const Text('Hồ sơ ứng tuyển: '),
                      Text(fileNamePdf!),
                      InkWell(
                        onTap: () async {
                          pickFile();
                        },
                        child: const Icon(Icons.upload_file),
                      )
                    ],
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 50,
                          width: Get.width * 0.7,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    print(pdfUrl);
                                    print(fileNamePdf);
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
                                        'Ứng tuyển',
                                        // 'login'.tr.capitalize,
                                        style: Style.titleStyle.copyWith(
                                            color: backgroundLite,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: CircleAvatar(
                            child: const Icon(
                              Icons.close,
                              size: 20,
                            ),
                            radius: 20,
                            backgroundColor: whiteColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class RegisterCompanyScreen extends StatefulWidget {
  final RegisterViewerArguments arguments;
  const RegisterCompanyScreen({super.key, required this.arguments});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  UserModel loggedInUser = UserModel();
  CompanyIntern? companyIntern;
  void initState() {
    super.initState();
    loggedInUser = widget.arguments.userModel;
    companyIntern = widget.arguments.companyIntern;
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String?> uploadPdf(String fileName, File file) async {
    final refrence = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = refrence.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await refrence.getDownloadURL();
    return downloadLink;
  }

  String? pdfUrl;
  String? fileNamePdf = 'Tải lên CV định dạng .pdf';
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

  Future<UserModel?> getUserForCompany(CompanyIntern company) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(company.idUserCanBo)
        .get();
    if (userSnapshot.exists) {
      UserModel user =
          UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      print(user.userName);
      return user;
    } else {
      print('null');
      return null; // Không tìm thấy người dùng tương ứng.
    }
  }

  Future<void> add_register(UserModel urserModel, CompanyIntern company) async {
    RegistrationModel registrationModel = RegistrationModel(
        positionApply: positionApply.text,
        nameCV: fileNamePdf ?? '',
        urlCV: pdfUrl ?? '',
        Company: company,
        user: urserModel,
        status: 'Đang duyệt',
        timestamp: Timestamp.now());
    await _firebaseFirestore
        .collection("registrations")
        .add(registrationModel.toMap())
        .then((documentReference) {
      String documentId = documentReference.id;
      documentReference.update({
        'id': documentId,
      }).then((_) {
        // In ID của tài liệu sau khi đã cập nhật
        Loading().isShowSuccess(
            'Ứng tuyển thành công !\nKiểm tra ở công ty đã đăng ký');
        print('ID của tài liệu vừa được thêm và cập nhật: $documentId');
      }).catchError((error) {
        // Xử lý lỗi nếu có khi cập nhật
        print('Lỗi khi cập nhật ID của tài liệu: $error');
      });
    });
    Get.back();
  }

  TextEditingController positionApply = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            color: background,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Hồ sơ của bạn'.toUpperCase(),
                    style: Style.hometitleStyle.copyWith(color: primaryColor)),
                TextFormReceipt(
                  lableText: 'Vị trí ứng tuyển', controller: positionApply,
                  icon: null,

                  // child: Text(
                  //   fileNamePdf!,
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                pdfUrl != null
                    ? InkWell(
                        onTap: () {
                          PdfViewerArguments arguments = PdfViewerArguments(
                            pdfUrl!,
                            fileNamePdf!,
                          );
                          Get.toNamed(RouteManager.pdfViewer,
                              arguments: arguments);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 115,
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
                                ' Xem lại CV',
                                style: TextStyle(color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 10),
                SizedBox(
                  width: Get.width,
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 50,
                        width: Get.width * 0.7,
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await Loading().isShowLoading();
                                    if (positionApply.text == '') {
                                      UIHelper.showFlushbar(
                                        message:
                                            'Vui lòng điền vị trí ứng tuyển !',
                                        snackBarType: SnackBarType.error,
                                      );
                                    } else if (pdfUrl == null) {
                                      UIHelper.showFlushbar(
                                        message:
                                            'Vui lòng tải lên CV để ứng tuyển !',
                                        snackBarType: SnackBarType.error,
                                      );
                                    } else {
                                      // UserModel? userCanBo =
                                      //     await getUserForCompany(companyIntern!);
                                      // Notifications notifications = Notifications(
                                      //   title: 'Bạn có yêu cầu ứng tuyển mới',
                                      //   body:
                                      //       '${loggedInUser.userName} đã ứng tuyển !. Kiểm tra ở chức năng "Xét duyệt, Lập phiếu"',
                                      //   timestamp: Timestamp.now(),
                                      //   emailUser: userCanBo!.email!,
                                      // );
                                      // await FirebaseFirestore.instance
                                      //     .collection('notifications')
                                      //     .add(
                                      //       notifications.toJson(),
                                      //     );
                                      // await FirebaseApi().sendFirebaseCloudMessage(
                                      //   notifications.title,
                                      //   notifications.body,
                                      //   userCanBo.fcmToken,
                                      // );
                                      await add_register(
                                        loggedInUser,
                                        companyIntern!,
                                      );
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
                                      'Ứng tuyển',
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
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          child: const Icon(
                            Icons.close,
                            size: 20,
                          ),
                          radius: 20,
                          backgroundColor: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 5),
                // const Text(
                //     'Kiểm tra thông tin ứng tuyển ở danh sách địa điểm đăng ký')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

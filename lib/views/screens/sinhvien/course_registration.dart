import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/course_register.dart';
import 'package:trungtamgiasu/models/hoc_phan.dart';
import 'package:trungtamgiasu/models/registration_model.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';

class CourseRegistrationScreen extends StatefulWidget {
  const CourseRegistrationScreen({super.key});

  @override
  State<CourseRegistrationScreen> createState() =>
      _CourseRegistrationScreenState();
}

class _CourseRegistrationScreenState extends State<CourseRegistrationScreen>
    with TickerProviderStateMixin {
  String? selectedSemester;
  String? selectedAcademicYear;
  bool showSearch = false;
  String? _search;
  UserModel loggedInUser = UserModel();
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  CollectionReference DKHPCollection =
      FirebaseFirestore.instance.collection('DangKyHocPhan');
  Future<bool?> getAllDKHP(String userID) async {
    QuerySnapshot querySnapshot = await DKHPCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DangKyHocPhan dangKyHocPhan = DangKyHocPhan.fromMap(data);
        if (dangKyHocPhan.user.uid == userID) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Đăng ký học phần',
            style: Style.homeTitleStyle,
          ),
          backgroundColor: primaryColor,
          actions: [
            InkWell(
              onTap: () async {
                if (showSearch == false) {
                  setState(() {
                    showSearch = true;
                  });
                } else {
                  setState(() {
                    showSearch = false;
                  });
                }
              },
              child: CircleAvatar(
                backgroundColor: whiteColor,
                radius: 17,
                child: const Icon(Icons.search_outlined),
              ),
            ),
            const SizedBox(width: 5),
          ],
          bottom: showSearch == true
              ? PreferredSize(
                  preferredSize:
                      Size.fromHeight(48.0), // Đặt chiều cao của phần bottom
                  child: Container(
                    color: whiteColor,
                    padding: EdgeInsets.all(1),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        hintText: 'Mã học phần',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _search = value;
                        setState(() {});
                        print(_search);
                      },
                    ),
                  ),
                )
              : null),
      body: Column(
        children: [
          TabBar(
            unselectedLabelStyle: Style.homesubtitleStyle,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'Danh sách học phần',
              ),
              Tab(
                text: 'Kết quả đăng ký học phần',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                DanhSachHocPhan(),
                KetQuaDangKyHocPhan(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> DanhSachHocPhan() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('HocKi').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: priceColor,
          ));
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('Không có dữ liệu.');
        } else {
          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          List<CourseRegistration> courseRegistrations = [];

          for (QueryDocumentSnapshot doc in documents) {
            String idDocument = doc.id;
            Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
            CourseRegistration courseRegistration =
                CourseRegistration.fromMap(jsonData);
            courseRegistration.id = idDocument;
            courseRegistrations.add(courseRegistration);
          }

          List<String> uniqueSemesters = courseRegistrations
              .map((courseRegistration) => courseRegistration.semester)
              .toSet()
              .toList();

          List<String> uniqueAcademicYears = courseRegistrations
              .map((courseRegistration) => courseRegistration.academicYear)
              .toSet()
              .toList();
          selectedSemester ??= uniqueSemesters.isNotEmpty
              ? uniqueSemesters.first
              : null; // Đặt giá trị đầu tiên nếu không có giá trị đã chọn
          selectedAcademicYear ??=
              uniqueAcademicYears.isNotEmpty ? uniqueAcademicYears.first : null;
          return ListView.builder(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: courseRegistrations.length,
            itemBuilder: (context, index) {
              CourseRegistration courseRegistration =
                  courseRegistrations[index];

              // Kiểm tra xem học kỳ và năm học có trùng với học kỳ và năm học đã chọn không
              if (courseRegistration.semester == selectedSemester &&
                  courseRegistration.academicYear == selectedAcademicYear) {
                // return InkWell(
                //   onTap: () async {
                //     try {
                //       final firestore = FirebaseFirestore.instance;
                //       for (var data in jsonHocPhanData) {
                //         // Thêm từng phần tử trong danh sách jsonData vào Firestore
                //         await firestore
                //             .collection('courseRegistrations')
                //             .doc(courseRegistration.id)
                //             .collection('AllCourse')
                //             .add(data);
                //       }
                //       print(
                //           'Dữ liệu đã được thêm vào Firestore thành công.');
                //     } catch (e) {
                //       print('Lỗi: $e');
                //     }
                //   },
                //   child: CircleAvatar(
                //     backgroundColor: blackColor,
                //     radius: 17,
                //     child: const Icon(Icons.add),
                //   ),
                // );
                return SingleChildScrollView(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('HocKi')
                        .doc(courseRegistration.id)
                        .collection('AllHocPhan')
                        .orderBy('maHocPhan')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Lỗi: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Expanded(
                          child: SizedBox(
                            height: Get.height * 0.85,
                            child: Image.asset(
                              'assets/images/nodata.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        List<QueryDocumentSnapshot> documents =
                            snapshot.data!.docs;
                        List<HocPhan> AllhocPhan = [];
                        for (QueryDocumentSnapshot doc in documents) {
                          String idDocument = doc.id;
                          Map<String, dynamic> jsonData =
                              doc.data() as Map<String, dynamic>;
                          HocPhan hocPhan = HocPhan.fromMap(jsonData);
                          hocPhan.id = idDocument;
                          AllhocPhan.add(hocPhan);
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: AllhocPhan.length,
                          itemBuilder: (context, index) {
                            HocPhan hocPhan = AllhocPhan[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(hocPhan.tenHocPhan),
                                      InkWell(
                                        onTap: () async {
                                          try {
                                            bool? checkDKHP = await getAllDKHP(
                                                loggedInUser.uid!);
                                            if (checkDKHP == true) {
                                              EasyLoading.showError(
                                                  'Bạn đã đằng ký học phần rồi !');
                                            } else {
                                              CollectionReference
                                                  courseRegistrationsCollection =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'DangKyHocPhan');
                                              DangKyHocPhan dangKyHocPhan =
                                                  DangKyHocPhan(
                                                idHK: courseRegistration.id!,
                                                idHP: hocPhan.id!,
                                                user: loggedInUser,
                                                idGiangVien:
                                                    hocPhan.idGiangVien,
                                                locationIntern: false,
                                                receiptForm: false,
                                                assignmentSlipForm: false,
                                                evaluation: false,
                                                isSubmitReport: false,
                                              );
                                              if (loggedInUser != null) {
                                                await courseRegistrationsCollection
                                                    .add(dangKyHocPhan.toMap())
                                                    .then((documentReference) {
                                                  String documentId =
                                                      documentReference.id;
                                                  documentReference.update({
                                                    'idDKHP': documentId
                                                  }).then((_) {
                                                    EasyLoading.showSuccess(
                                                        'Đăng ký thành công !\n Kiểm ra ở kết quả ĐKHP');
                                                    print(
                                                        'ID của tài liệu vừa được thêm và cập nhật: $documentId');
                                                  }).catchError((error) {
                                                    print(
                                                        'Lỗi khi cập nhật ID của tài liệu: $error');
                                                  });
                                                }).catchError((error) {
                                                  print(
                                                      'Lỗi khi thêm tài liệu: $error');
                                                });
                                              } else {
                                                print(
                                                    'Biến loggedInUser có giá trị null. Không thể thêm dữ liệu.');
                                              }
                                            }
                                          } catch (e) {
                                            print('Lỗi: $e');
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            color: primaryColor,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.app_registration,
                                                color: whiteColor,
                                              ),
                                              Text(
                                                'Đăng ký HP',
                                                style: TextStyle(
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Mã HP'),
                                          Text(hocPhan.maHocPhan),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Ký hiệu'),
                                          Text(hocPhan.kyHieu),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Lớp'),
                                          Text(hocPhan.lop),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Cán bộ giảng dạy'),
                                          Text(hocPhan.giaoVien),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              } else {
                return Container(); // Không hiển thị nếu không trùng
              }
            },
          );
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> KetQuaDangKyHocPhan() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('courseRegistrations')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('Không có dữ liệu.');
        } else {
          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          List<CourseRegistration> courseRegistrations = [];

          for (QueryDocumentSnapshot doc in documents) {
            String idDocument = doc.id;
            Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
            CourseRegistration courseRegistration =
                CourseRegistration.fromMap(jsonData);
            courseRegistration.id = idDocument;
            courseRegistrations.add(courseRegistration);
          }

          List<String> uniqueSemesters = courseRegistrations
              .map((courseRegistration) => courseRegistration.semester)
              .toSet()
              .toList();

          List<String> uniqueAcademicYears = courseRegistrations
              .map((courseRegistration) => courseRegistration.academicYear)
              .toSet()
              .toList();
          return ListView.builder(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: courseRegistrations.length,
            itemBuilder: (context, index) {
              CourseRegistration courseRegistration =
                  courseRegistrations[index];
              // Kiểm tra xem học kỳ và năm học có trùng với học kỳ và năm học đã chọn không
              if (courseRegistration.semester == selectedSemester &&
                  courseRegistration.academicYear == selectedAcademicYear) {
                return SingleChildScrollView(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('DangKyHocPhan')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(
                          child: SizedBox(
                            height: Get.height * 0.85,
                            child: Image.asset(
                              'assets/images/nodata.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Lỗi: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Expanded(
                          child: SizedBox(
                            height: Get.height * 0.85,
                            child: Image.asset(
                              'assets/images/nodata.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        List<QueryDocumentSnapshot> documents =
                            snapshot.data!.docs;
                        List<DangKyHocPhan> dangKyHocPhanList = [];
                        for (QueryDocumentSnapshot doc in documents) {
                          Map<String, dynamic> jsonData =
                              doc.data() as Map<String, dynamic>;
                          DangKyHocPhan dangKyHocPhan =
                              DangKyHocPhan.fromMap(jsonData);
                          dangKyHocPhanList.add(dangKyHocPhan);
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dangKyHocPhanList.length,
                          itemBuilder: (context, index) {
                            DangKyHocPhan dkHocPhan = dangKyHocPhanList[index];
                            return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('HocKi')
                                    .doc(dkHocPhan.idHK)
                                    .collection('AllHocPhan')
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Lỗi: ${snapshot.error}');
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return Expanded(
                                      child: SizedBox(
                                        height: Get.height * 0.85,
                                        child: Image.asset(
                                          'assets/images/nodata.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  } else {
                                    List<QueryDocumentSnapshot> documents =
                                        snapshot.data!.docs;
                                    List<HocPhan> hocPhanList = [];
                                    for (QueryDocumentSnapshot doc
                                        in documents) {
                                      Map<String, dynamic> jsonData =
                                          doc.data() as Map<String, dynamic>;
                                      HocPhan hocPhan =
                                          HocPhan.fromMap(jsonData);
                                      hocPhanList.add(hocPhan);
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: hocPhanList.length,
                                      itemBuilder: (context, index) {
                                        HocPhan hocPhan = hocPhanList[index];
                                        if (hocPhan.id == dkHocPhan.idHP &&
                                            dkHocPhan.user.uid ==
                                                loggedInUser.uid) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(hocPhan.tenHocPhan),
                                                  ],
                                                ),
                                                subtitle: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text('Mã HP'),
                                                        Text(hocPhan.maHocPhan),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text('Ký hiệu'),
                                                        Text(hocPhan.kyHieu),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text('Lớp'),
                                                        Text(hocPhan.lop),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                            'Cán bộ giảng dạy'),
                                                        Text(hocPhan.giaoVien),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(),
                                            ],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    );
                                  }
                                });
                          },
                        );
                      }
                    },
                  ),
                );
              } else {
                return Container(); // Không hiển thị nếu không trùng
              }
            },
          );
        }
      },
    );
  }
}

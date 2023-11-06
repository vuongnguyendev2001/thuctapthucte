import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/constants/ui_helper.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/tim_kiem_dia_diem/tim_kiem_dia_diem.dart';

class WaitingAcceptAccount extends StatefulWidget {
  const WaitingAcceptAccount({super.key});

  @override
  State<WaitingAcceptAccount> createState() => _WaitingAcceptAccountState();
}

class _WaitingAcceptAccountState extends State<WaitingAcceptAccount>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        title: Text(
          'Danh sách tài khoản công ty',
          style: Style.homeTitleStyle,
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            unselectedLabelStyle: Style.homesubtitleStyle,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'Chờ duyệt',
              ),
              Tab(
                text: 'Đã duyệt',
              ),
              Tab(
                text: 'Đã từ chối',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                waitingList(),
                AcceptList(),
                RejectList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> waitingList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("waitingReview").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Dữ liệu đã tải thành công từ Firestore
          List<CompanyIntern> companies = [];
          List<CompanyIntern> companiesWaiting = [];
          List<CompanyIntern> companiesReject = [];
          List<CompanyIntern> companiesAccept = [];
          for (QueryDocumentSnapshot document in snapshot.data!.docs) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            CompanyIntern company = CompanyIntern.fromMap(data);
            if (company.status == 'Chờ duyệt') {
              companiesWaiting.add(company);
            }
          }
          if (companiesWaiting.isEmpty == true) {
            return Center(
              child: Text(
                'Không có công ty chờ duyệt',
                style: Style.subtitleBlackGiaovuStyle,
              ),
            );
          }
          return ListView.builder(
            itemCount: companiesWaiting.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        JdCompany(context, companiesWaiting, index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: textBoxLite,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: const Icon(
                            Icons.arrow_right_outlined,
                          ),
                          leading: Text('${index + 1}'),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tuyển dụng: ${companiesWaiting[index].position!}',
                                style: Style.titleStyle.copyWith(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                companiesWaiting[index].name!.toUpperCase(),
                                style: Style.titlegreyStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_city_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  Text(
                                    companiesWaiting[index].location!,
                                    style: Style.titlegreyStyle,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Trạng thái: '),
                                  Text(
                                    companiesWaiting[index].status.toString(),
                                  ),
                                ],
                              ),
                            ],
                            // Hiển thị các thông tin khác của công ty
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          // Xử lý lỗi
          return Center(
            child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> AcceptList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("waitingReview").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Dữ liệu đã tải thành công từ Firestore
          List<CompanyIntern> companies = [];
          List<CompanyIntern> companiesWaiting = [];
          List<CompanyIntern> companiesReject = [];
          List<CompanyIntern> companiesAccept = [];
          for (QueryDocumentSnapshot document in snapshot.data!.docs) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            CompanyIntern company = CompanyIntern.fromMap(data);
            if (company.status == 'Đã duyệt') {
              companiesWaiting.add(company);
            }
          }
          if (companiesWaiting.isEmpty == true) {
            return SizedBox(
              height: Get.height,
              width: Get.width,
              child: Center(
                child: Text(
                  'Không có tài khoản đã duyệt',
                  style: Style.subtitleBlackGiaovuStyle,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: companiesWaiting.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        JdCompany(context, companiesWaiting, index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: textBoxLite,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: const Icon(
                            Icons.arrow_right_outlined,
                          ),
                          leading: Text('${index + 1}'),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tuyển dụng: ${companiesWaiting[index].position!}',
                                style: Style.titleStyle.copyWith(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                companiesWaiting[index].name!.toUpperCase(),
                                style: Style.titlegreyStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_city_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  Text(
                                    companiesWaiting[index].location!,
                                    style: Style.titlegreyStyle,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Trạng thái: '),
                                  Text(
                                    companiesWaiting[index].status.toString(),
                                  ),
                                ],
                              ),
                            ],
                            // Hiển thị các thông tin khác của công ty
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          // Xử lý lỗi
          return Center(
            child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> RejectList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("waitingReview").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Dữ liệu đã tải thành công từ Firestore
          List<CompanyIntern> companies = [];
          List<CompanyIntern> companiesWaiting = [];
          List<CompanyIntern> companiesReject = [];
          List<CompanyIntern> companiesAccept = [];
          for (QueryDocumentSnapshot document in snapshot.data!.docs) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            CompanyIntern company = CompanyIntern.fromMap(data);
            if (company.status == 'Đã từ chối') {
              companiesWaiting.add(company);
            }
          }
          if (companiesWaiting.isEmpty == true) {
            return SizedBox(
              height: Get.height,
              width: Get.width,
              child: Center(
                child: Text(
                  'Không có công ty từ chối',
                  style: Style.subtitleBlackGiaovuStyle,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: companiesWaiting.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        JdCompany(context, companiesWaiting, index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: textBoxLite,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: const Icon(
                            Icons.arrow_right_outlined,
                          ),
                          leading: Text('${index + 1}'),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tuyển dụng: ${companiesWaiting[index].position!}',
                                style: Style.titleStyle.copyWith(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                companiesWaiting[index].name!.toUpperCase(),
                                style: Style.titlegreyStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_city_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  Text(
                                    companiesWaiting[index].location!,
                                    style: Style.titlegreyStyle,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Trạng thái: '),
                                  Text(
                                    companiesWaiting[index].status.toString(),
                                  ),
                                ],
                              ),
                            ],
                            // Hiển thị các thông tin khác của công ty
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          // Xử lý lỗi
          return Center(
            child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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
                              companies[index].position!,
                              style: Style.titleStyle,
                            ),
                            const SizedBox(height: 10),
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       child: Image.network(
                            //         companies[index].logo!,
                            //         height: 55,
                            //         width: 55,
                            //       ),
                            //     ),
                            //     const SizedBox(width: 10),
                            Text(
                              companies[index].name!.toUpperCase(),
                              style: Style.titlegreyStyle,
                            ),
                            //   ],
                            // ),
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
                              companies[index]
                                  .companyDetail!
                                  .internshipPosition,
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
                              companies[index].companyDetail!.benefits,
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
                              companies[index]
                                  .companyDetail!
                                  .internshipDuration,
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
                              companies[index].companyDetail!.address,
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
                              companies[index].companyDetail!.applicationMethod,
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
                  ElevatedButton(
                    onPressed: () async {
                      UIHelper.showCupertinoDialog(
                        onComfirm: () {
                          CompanyIntern companyIntern = companies[index];
                          // FirebaseFirestore.instance
                          //     .collection('companies')
                          //     .doc(companies[index].id!)
                          //     .set(
                          //       companyIntern.toMap(),
                          //     );
                          FirebaseFirestore.instance
                              .collection('waitingReview')
                              .doc(companyIntern.id!)
                              .update({
                            "status": "Đã duyệt",
                          });
                          EasyLoading.showSuccess(
                            'Duyệt công ty thành công!',
                          );
                          Get.back();
                          Get.back();
                        },
                        title: 'Thông báo',
                        isShowClose: true,
                        isShowConfirm: true,
                        titleClose: 'Đóng',
                        titleConfirm: 'Đồng ý',
                        message: 'Đồng ý duyệt công ty',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(Get.width * 0.20, 44),
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
                          'Xét duyệt',
                          // 'login'.tr.capitalize,
                          style: Style.titleStyle
                              .copyWith(color: backgroundLite, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          UIHelper.showCupertinoDialog(
                            onComfirm: () {
                              FirebaseFirestore.instance
                                  .collection('waitingReview')
                                  .doc(companies[index].id!)
                                  .update({"status": "Đã từ chối"});
                              EasyLoading.showSuccess('Đã từ chối công ty !');
                              Get.back();
                              Get.back();
                            },
                            title: 'Thông báo',
                            isShowClose: true,
                            isShowConfirm: true,
                            titleClose: 'Đóng',
                            titleConfirm: 'Đồng ý',
                            message: 'Từ chối duyệt tài khoản',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(Get.width * 0.20, 44),
                          elevation: 0.0,
                          backgroundColor: primaryOpacity,
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
                              Icons.close_outlined,
                              color: backgroundLite,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              'Từ chối',
                              // 'login'.tr.capitalize,
                              style: Style.titleStyle.copyWith(
                                  color: backgroundLite, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
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
}

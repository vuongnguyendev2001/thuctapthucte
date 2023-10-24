import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/lecturers_evaluation_model.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
import 'package:trungtamgiasu/models/result_evaluation.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/receipt_form_screen.dart';
import 'package:trungtamgiasu/views/widgets/custom_results_evaluation.dart';

class LecturersEvaluationDetail extends StatefulWidget {
  const LecturersEvaluationDetail({super.key});

  @override
  State<LecturersEvaluationDetail> createState() =>
      _LecturersEvaluationDetailState();
}

class _LecturersEvaluationDetailState extends State<LecturersEvaluationDetail> {
  Stream<DocumentSnapshot>? lecturersEvaluationFirestore;

  String idDocument = '';
  String? sumScoreCanBo = ''; // Make sumScoreCanBo nullable
  sumScoreAndIdDocParameters? scoreAndIdDoc;
  TextEditingController correctFormat = TextEditingController();
  TextEditingController wellPresented = TextEditingController();
  TextEditingController haveAWorkSchedule = TextEditingController();
  TextEditingController suitableMethod = TextEditingController();
  TextEditingController companyValuation = TextEditingController();
  TextEditingController understandingAboutInternLocation =
      TextEditingController();
  TextEditingController reinforceTheory = TextEditingController();
  TextEditingController suitableWorkout = TextEditingController();
  TextEditingController practicalExperience = TextEditingController();
  TextEditingController haveContributed = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController lecturers = TextEditingController();
  TextEditingController scoreTotal = TextEditingController();
  void updateTotal() {
    double correctFormatValue = double.tryParse(correctFormat.text) ?? 0;
    double wellPresentedValue = double.tryParse(wellPresented.text) ?? 0;
    double haveAWorkScheduleValue =
        double.tryParse(haveAWorkSchedule.text) ?? 0;
    double companyValuationValue = double.tryParse(companyValuation.text) ?? 0;
    double suitableMethodValue = double.tryParse(suitableMethod.text) ?? 0;
    double understandingAboutInternLocationValue =
        double.tryParse(understandingAboutInternLocation.text) ?? 0;
    double reinforceTheoryValue = double.tryParse(reinforceTheory.text) ?? 0;
    double suitableWorkoutValue = double.tryParse(suitableWorkout.text) ?? 0;
    double practicalExperienceValue =
        double.tryParse(practicalExperience.text) ?? 0;
    double haveContributedValue = double.tryParse(haveContributed.text) ?? 0;
    //  double correctFormatValue =
    // double.tryParse(correctFormat.text) ?? 0;
    double sumTotal = correctFormatValue +
        wellPresentedValue +
        haveAWorkScheduleValue +
        suitableMethodValue +
        companyValuationValue +
        understandingAboutInternLocationValue +
        reinforceTheoryValue +
        suitableWorkoutValue +
        practicalExperienceValue +
        haveContributedValue;
    total.text = sumTotal.toString();
  }

  Future<void> fetchData() async {
    final updatedUser = await getUserInfo(loggedInUser);
    setState(() {
      loggedInUser = updatedUser;
    });
  }

  double? sumCaculator;
  @override
  void initState() {
    super.initState();
    fetchData();
    scoreAndIdDoc = Get.arguments as sumScoreAndIdDocParameters;
    idDocument = scoreAndIdDoc!.idDKHP;
    sumScoreCanBo = scoreAndIdDoc!.sumScoreCanBo; // Initialize idDocument
    lecturersEvaluationFirestore = FirebaseFirestore.instance
        .collection('DangKyHocPhan')
        .doc(idDocument)
        .snapshots();
    correctFormat.addListener(updateTotal);
    wellPresented.addListener(updateTotal);
    haveAWorkSchedule.addListener(updateTotal);
    companyValuation.addListener(updateTotal);
    suitableMethod.addListener(updateTotal);
    understandingAboutInternLocation.addListener(updateTotal);
    reinforceTheory.addListener(updateTotal);
    suitableWorkout.addListener(updateTotal);
    practicalExperience.addListener(updateTotal);
    haveContributed.addListener(updateTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Phiếu đánh giá kết quả'.toUpperCase(),
          style: Style.homeStyle,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: StreamBuilder(
              stream: lecturersEvaluationFirestore,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
                final Map<String, dynamic> data =
                    snapshot.data?.data() as Map<String, dynamic>? ?? {};
                DangKyHocPhan lecturersEvaluation = DangKyHocPhan.fromMap(data);
                TextEditingController nameStudent = TextEditingController(
                    text: lecturersEvaluation.user.userName);
                TextEditingController mssvStudent =
                    TextEditingController(text: lecturersEvaluation.user.MSSV);
                TextEditingController reportName =
                    TextEditingController(text: 'Sinh viên chưa nộp báo cáo');

                companyValuation = TextEditingController(text: 'Chưa đánh giá');
                if (lecturersEvaluation.submitReport!.titleReport != null) {
                  reportName = TextEditingController(
                      text: lecturersEvaluation.submitReport!.titleReport);
                }
                if (sumScoreCanBo != null) {
                  double sumScoreCanBoString = double.parse(sumScoreCanBo!);
                  sumCaculator = (sumScoreCanBoString / 100) * 5;
                  companyValuation =
                      TextEditingController(text: sumCaculator.toString());
                }
                if (lecturersEvaluation.lecturersEvaluation != null) {
                  correctFormat = TextEditingController(
                      text: lecturersEvaluation
                          .lecturersEvaluation!.correctFormat);
                  wellPresented = TextEditingController(
                      text: lecturersEvaluation
                          .lecturersEvaluation!.wellPresented);
                  haveAWorkSchedule = TextEditingController(
                      text: lecturersEvaluation
                          .lecturersEvaluation!.haveAWorkSchedule);
                  suitableMethod = TextEditingController(
                      text: lecturersEvaluation
                          .lecturersEvaluation!.suitableMethod);
                  reportName = TextEditingController(
                      text: lecturersEvaluation.submitReport!.titleReport);
                  understandingAboutInternLocation = TextEditingController(
                      text: lecturersEvaluation.lecturersEvaluation!
                          .understandingAboutInternLocation);
                  reinforceTheory = TextEditingController(
                      text: lecturersEvaluation
                          .lecturersEvaluation!.reinforceTheory);
                  suitableWorkout = TextEditingController(
                      text: lecturersEvaluation
                          .lecturersEvaluation!.suitableWorkout);
                  practicalExperience = TextEditingController(
                      text: lecturersEvaluation
                          .lecturersEvaluation!.practicalExperience);
                  haveContributed = TextEditingController(
                      text: lecturersEvaluation
                          .lecturersEvaluation!.haveContributed);
                  total = TextEditingController(
                      text: lecturersEvaluation.lecturersEvaluation!.total);
                  lecturers = TextEditingController(
                      text: lecturersEvaluation.lecturersEvaluation!.lecturers);
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormReceipt(
                                isReadOnly: true,
                                controller: nameStudent,
                                lableText: 'Họ và tên SV',
                                icon: null,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: TextFormReceipt(
                                isReadOnly: true,
                                controller: mssvStudent,
                                lableText: 'Mã số SV',
                                icon: null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormReceipt(
                          isReadOnly: true,
                          controller: reportName,
                          lableText: 'Tên file báo cáo',
                          icon: null,
                        ),
                        const SizedBox(height: 10),
                        lecturersEvaluation.submitReport != null
                            ? InkWell(
                                onTap: () {
                                  PdfViewerArguments arguments =
                                      PdfViewerArguments(
                                    lecturersEvaluation.submitReport!.urlReport,
                                    lecturersEvaluation
                                        .submitReport!.titleReport,
                                  );
                                  Get.toNamed(
                                    RouteManager.pdfViewer,
                                    arguments: arguments,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: Get.width * 0.5,
                                    height: 40,
                                    color: primaryColor,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Xem báo cáo',
                                          style: Style.titleStyle.copyWith(
                                              color: backgroundLite,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: backgroundLite,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(),
                            1: FixedColumnWidth(67),
                            2: FixedColumnWidth(67)
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'Nội dung đánh giá',
                                    style: Style.titleStyle,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Điểm tối đa',
                                    style: Style.titleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Điểm chấm',
                                    style: Style.titleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' I. Hình thức trình bày',
                                  style: Style.titleStyle,
                                ),
                                Text(
                                  '1.0',
                                  style: Style.titleStyle,
                                ),
                                Container(),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'I.1 Đúng format của khoa (Trang bìa, trang lời cảm ơn, trang đánh giá thực tập của khoa,  trang mục lục và các nội dung báo cáo). Sử dụng đúng mã và font tiếng Việt (Unicode Times New Roman, Size 13)',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '0.5',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: correctFormat,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'I.2 Trình bày mạch lạc, súc tích, không có lỗi chính tả',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '0.5',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: wellPresented,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' I. Phiếu theo dõi',
                                  style: Style.titleStyle,
                                ),
                                Text(
                                  '6.0',
                                  style: Style.titleStyle,
                                ),
                                Container(),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'II.1 Có lịch làm việc đầy đủ cho 8 tuần',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '1.0',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: haveAWorkSchedule,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'II.3 Hoàn thành tốt kế hoạch công tác ghi trong lịch làm việc. Cách tính điểm = (Điểm cộng của cán bộ hướng dẫn/100) x 5',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '5.0',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  isReadOnly: true,
                                  controller: companyValuation,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' III. Nội dung thực tập (quyển báo cáo)',
                                  style: Style.titleStyle,
                                ),
                                Text(
                                  '3.0',
                                  style: Style.titleStyle,
                                ),
                                Container(),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'III.1 Có được sự hiểu biết tốt về cơ quan nơi thực tập',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '0.5',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: understandingAboutInternLocation,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'III.2 Phương pháp thực hiện phù hợp với nội dung công việc được giao',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '0.5',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: suitableMethod,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'III.3 Kết quả củng cố lý thuyết',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '0.5',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: reinforceTheory,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'III.4 Kết quả rèn luyện kỹ năng thực hành',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '0.5',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: suitableWorkout,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'III.5 Kinh nghiệm thực tiễn thu nhận được',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '0.5',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: practicalExperience,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'III.6 Kết quả công việc có đóng góp cho cơ quan nơi thực tập',
                                    style: Style.subtitleStyle,
                                  ),
                                ),
                                Text(
                                  '0.5',
                                  style: Style.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: haveContributed,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' Tổng cộng'.toUpperCase(),
                                  style: Style.titleStyle,
                                ),
                                Text(
                                  '10',
                                  style: Style.titleStyle,
                                  textAlign: TextAlign.center,
                                ),
                                CustomResultsEvaluation(
                                  controller: total,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        lecturers.text != ''
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'GV chấm: ${lecturers.text}',
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
                              double correctFormatValue =
                                  double.tryParse(correctFormat.text) ?? 0;
                              double wellPresentedValue =
                                  double.tryParse(wellPresented.text) ?? 0;
                              double haveAWorkScheduleValue =
                                  double.tryParse(haveAWorkSchedule.text) ?? 0;
                              double companyValuationValue =
                                  double.tryParse(companyValuation.text) ?? 0;
                              double suitableMethodValue =
                                  double.tryParse(suitableMethod.text) ?? 0;
                              double understandingAboutInternLocationValue =
                                  double.tryParse(
                                          understandingAboutInternLocation
                                              .text) ??
                                      0;
                              double reinforceTheoryValue =
                                  double.tryParse(reinforceTheory.text) ?? 0;
                              double suitableWorkoutValue =
                                  double.tryParse(suitableWorkout.text) ?? 0;
                              double practicalExperienceValue =
                                  double.tryParse(practicalExperience.text) ??
                                      0;
                              double haveContributedValue =
                                  double.tryParse(haveContributed.text) ?? 0;
                              double sumTotal = correctFormatValue +
                                  wellPresentedValue +
                                  haveAWorkScheduleValue +
                                  suitableMethodValue +
                                  companyValuationValue +
                                  understandingAboutInternLocationValue +
                                  reinforceTheoryValue +
                                  suitableWorkoutValue +
                                  practicalExperienceValue +
                                  haveContributedValue;
                              total.text = sumTotal.toString();
                              if (sumTotal < 4) {
                                scoreTotal.text = 'F';
                              } else if (sumTotal >= 4 && sumTotal <= 5) {
                                scoreTotal.text = 'D';
                              } else if (sumTotal > 5 && sumTotal <= 6) {
                                scoreTotal.text = 'D+';
                              } else if (sumTotal > 6 && sumTotal < 6.5) {
                                scoreTotal.text = 'C';
                              } else if (sumTotal >= 6.5 && sumTotal < 7) {
                                scoreTotal.text = 'C+';
                              } else if (sumTotal >= 7 && sumTotal < 8) {
                                scoreTotal.text = 'B';
                              } else if (sumTotal >= 8 && sumTotal < 9) {
                                scoreTotal.text = 'B+';
                              } else {
                                scoreTotal.text = 'A';
                              }
                              LecturersEvaluation lectureEvaluation =
                                  LecturersEvaluation(
                                correctFormat: correctFormat.text,
                                wellPresented: wellPresented.text,
                                haveAWorkSchedule: haveAWorkSchedule.text,
                                companyValuation: companyValuation.text,
                                understandingAboutInternLocation:
                                    understandingAboutInternLocation.text,
                                suitableMethod: suitableMethod.text,
                                reinforceTheory: reinforceTheory.text,
                                practicalExperience: practicalExperience.text,
                                haveContributed: haveContributed.text,
                                suitableWorkout: suitableWorkout.text,
                                lecturers: loggedInUser.userName,
                                total: total.text,
                                totalScore: scoreTotal.text,
                              );
                              await FirebaseFirestore.instance
                                  .collection('DangKyHocPhan')
                                  .doc(idDocument)
                                  .update({
                                "lecturersEvaluation": lectureEvaluation.toMap()
                              }).then((_) {
                                EasyLoading.showSuccess(
                                  'Lập phiếu thành công!',
                                );
                                // Get.back();
                              }).catchError((error) {
                                // Xử lý lỗi nếu có khi cập nhật
                                print('$error');
                              });
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
                                  'Hoàn thành phiếu',
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
          ),
        ],
      ),
    );
  }
}

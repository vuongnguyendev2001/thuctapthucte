import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/models/DKHP.dart';
import 'package:trungtamgiasu/models/assignment_slip.dart';
import 'package:trungtamgiasu/models/result_evaluation.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/services/get_current_user.dart';
import 'package:trungtamgiasu/views/screens/canbohuongdan/receipt_form_screen.dart';
import 'package:trungtamgiasu/views/widgets/custom_results_evaluation.dart';

class ResultsEvaluationDetail extends StatefulWidget {
  const ResultsEvaluationDetail({super.key});

  @override
  State<ResultsEvaluationDetail> createState() =>
      _ResultsEvaluationDetailState();
}

class _ResultsEvaluationDetailState extends State<ResultsEvaluationDetail> {
  String idDocument = ''; // Declare idDocument
  Stream<DocumentSnapshot>? resultsEvaluationFirestore;
  bool showSearch = false;
  bool? consistentWithReality = false;
  bool? doesNotMatchReality = false;
  bool? enhanceSoftSkills = false;
  bool? strengThenForeignLanguages = false;
  bool? enhanceTeamworkSkills = false;
  TextEditingController sumController = TextEditingController();
  TextEditingController implementTheRulesWell =
      TextEditingController(text: '10');
  TextEditingController complyWithWorkingHours =
      TextEditingController(text: '10');
  TextEditingController attitude = TextEditingController(text: '10');
  TextEditingController positiveInWork = TextEditingController(text: '10');
  TextEditingController meetJobRequirements = TextEditingController(text: '10');
  TextEditingController spiritOfLearning = TextEditingController(text: '10');
  TextEditingController haveSuggestions = TextEditingController(text: '10');
  TextEditingController progressReport = TextEditingController(text: '10');
  TextEditingController completeTheWork = TextEditingController(text: '10');
  TextEditingController workResults = TextEditingController(text: '10');
  TextEditingController otherCommentsAboutStudents = TextEditingController();
  TextEditingController suggestedComments = TextEditingController(text: '10');
  TextEditingController idStudent = TextEditingController();
  void updateSum() {
    double implementTheRulesWellValue =
        double.tryParse(implementTheRulesWell.text) ?? 0;
    double complyWithWorkingHoursValue =
        double.tryParse(complyWithWorkingHours.text) ?? 0;
    double attitudeValue = double.tryParse(attitude.text) ?? 0;
    double positiveInWorkValue = double.tryParse(positiveInWork.text) ?? 0;
    double meetJobRequirementsValue =
        double.tryParse(meetJobRequirements.text) ?? 0;
    double spiritOfLearningValue = double.tryParse(spiritOfLearning.text) ?? 0;
    double haveSuggestionsValue = double.tryParse(haveSuggestions.text) ?? 0;
    double progressReportValue = double.tryParse(progressReport.text) ?? 0;
    double completeTheWorkValue = double.tryParse(completeTheWork.text) ?? 0;
    double workResultsValue = double.tryParse(workResults.text) ?? 0;
    double sumScore = implementTheRulesWellValue +
        complyWithWorkingHoursValue +
        attitudeValue +
        positiveInWorkValue +
        meetJobRequirementsValue +
        spiritOfLearningValue +
        haveSuggestionsValue +
        progressReportValue +
        completeTheWorkValue +
        workResultsValue;
    sumController.text = sumScore.toString();
  }

  @override
  void initState() {
    super.initState();
    updateSum();
    implementTheRulesWell.addListener(updateSum);
    complyWithWorkingHours.addListener(updateSum);
    attitude.addListener(updateSum);
    positiveInWork.addListener(updateSum);
    meetJobRequirements.addListener(updateSum);
    spiritOfLearning.addListener(updateSum);
    haveSuggestions.addListener(updateSum);
    progressReport.addListener(updateSum);
    spiritOfLearning.addListener(updateSum);
    completeTheWork.addListener(updateSum);
    workResults.addListener(updateSum);
    idDocument = Get.arguments as String; // Initialize idDocument
    resultsEvaluationFirestore = FirebaseFirestore.instance
        .collection('ResultsEvaluation')
        .doc(idDocument)
        .snapshots();
  }

  CollectionReference DKHPCollection =
      FirebaseFirestore.instance.collection('DangKyHocPhan');
  Future<String?> getAllDKHP(String userID) async {
    int count = 0;
    QuerySnapshot querySnapshot = await DKHPCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (QueryDocumentSnapshot document in documents) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        DangKyHocPhan dangKyHocPhan = DangKyHocPhan.fromMap(data);
        if (dangKyHocPhan.user.uid == userID) {
          print(dangKyHocPhan.idDKHP);
          return dangKyHocPhan.idDKHP;
        }
      }
    }
    return 'No data';
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
          StreamBuilder(
            stream: resultsEvaluationFirestore,
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
              ResultEvaluation resultEvaluationList =
                  ResultEvaluation.fromMap(data);
              idStudent.text = resultEvaluationList.userStudent!.uid!;
              TextEditingController nameStudent = TextEditingController(
                  text: resultEvaluationList.userStudent?.userName);
              TextEditingController mssvController = TextEditingController(
                  text: resultEvaluationList.userStudent?.MSSV);
              TextEditingController nameCompanyController =
                  TextEditingController(
                      text: resultEvaluationList.companyIntern?.name);
              TextEditingController nameCanBoController = TextEditingController(
                  text: resultEvaluationList.userCanBo?.userName);
              TextEditingController emailCanBoController =
                  TextEditingController(
                      text: resultEvaluationList.userCanBo?.email);
              TextEditingController phoneCanBoController =
                  TextEditingController(
                      text: resultEvaluationList.userCanBo?.phoneNumberCanBo);
              if (resultEvaluationList.implementTheRulesWell != null) {
                implementTheRulesWell = TextEditingController(
                    text: resultEvaluationList.implementTheRulesWell);
                complyWithWorkingHours = TextEditingController(
                    text: resultEvaluationList.complyWithWorkingHours);
                attitude =
                    TextEditingController(text: resultEvaluationList.attitude);
                positiveInWork = TextEditingController(
                    text: resultEvaluationList.positiveInWork);
                meetJobRequirements = TextEditingController(
                    text: resultEvaluationList.meetJobRequirements);
                spiritOfLearning = TextEditingController(
                    text: resultEvaluationList.spiritOfLearning);
                haveSuggestions = TextEditingController(
                    text: resultEvaluationList.haveSuggestions);
                progressReport = TextEditingController(
                    text: resultEvaluationList.progressReport);
                workResults = TextEditingController(
                    text: resultEvaluationList.workResults);
                completeTheWork = TextEditingController(
                    text: resultEvaluationList.completeTheWork);
                otherCommentsAboutStudents = TextEditingController(
                    text: resultEvaluationList.otherCommentsAboutStudents);
                suggestedComments = TextEditingController(
                    text: resultEvaluationList.suggestedComments);
                consistentWithReality =
                    resultEvaluationList.consistentWithReality;
                doesNotMatchReality = resultEvaluationList.doesNotMatchReality;
                enhanceSoftSkills = resultEvaluationList.enhanceSoftSkills;
                enhanceTeamworkSkills =
                    resultEvaluationList.enhanceTeamworkSkills;
                strengThenForeignLanguages =
                    resultEvaluationList.strengThenForeignLanguages;
                sumController =
                    TextEditingController(text: resultEvaluationList.sumScore);
              }
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormReceipt(
                                isReadOnly: true,
                                controller: nameCanBoController,
                                lableText: 'Họ và tên cán bộ',
                                icon: null,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: TextFormReceipt(
                                isReadOnly: true,
                                controller: emailCanBoController,
                                lableText: 'Email',
                                icon: null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormReceipt(
                          isReadOnly: true,
                          controller: nameCompanyController,
                          lableText: 'Tên cơ quan',
                          icon: const Icon(Icons.abc_outlined),
                        ),
                        const SizedBox(height: 15),
                        TextFormReceipt(
                          isReadOnly: true,
                          controller: phoneCanBoController,
                          lableText: 'Số điện thoại cán bộ',
                          icon: const Icon(Icons.abc_outlined),
                        ),
                        const SizedBox(height: 15),
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
                                controller: mssvController,
                                lableText: 'Mã số SV',
                                icon: null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: 'Thời gian thực tập: ',
                            style: Style.subtitleStyle,
                            children: const <TextSpan>[
                              TextSpan(text: ' từ ngày '),
                              TextSpan(
                                  text: '15/5/2023',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' đến'),
                              TextSpan(
                                  text: ' 8/7/2023',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Table(
                          border: TableBorder.all(),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(),
                            1: FixedColumnWidth(67),
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
                                    '   Điểm (từ 1-10)',
                                    style: Style.titleStyle,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' I. Tinh thần kỷ luật',
                                  style: Style.titleStyle,
                                ),
                                Container(),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' I.1. Thực hiện nội quy của cơ quan\n(nếu thực tập online thì không chấm điểm)',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: implementTheRulesWell,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' I.2. Chấp hành giờ giấc làm việc\n (nếu thực tập online thì không chấm điểm)',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: complyWithWorkingHours,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' I.3. Thái độ giao tiếp với cán bộ trong đơn vị (nếu thực tập online thì không chấm điểm)',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: attitude,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' I.4. Tích cực trong công việc',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: positiveInWork,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' II. Khả năng chuyên môn, nghiệp vụ',
                                  style: Style.titleStyle,
                                ),
                                Container(),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' II.1. Đáp ứng yêu cầu công việc',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: meetJobRequirements,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' II.2. Tinh thần học hỏi, nâng cao trình độ chuyên môn, nghiệp vụ',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: spiritOfLearning,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' II.3. Có đề xuất, sáng kiến, năng động trong công việc',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: haveSuggestions,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' III. Kết quả công tác',
                                  style: Style.titleStyle,
                                ),
                                Container(),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' III.1. Báo cáo tiến độ công việc cho cán bộ hướng dẫn mỗi tuần 1 lần',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: progressReport,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' III.2. Hoàn thành công việc được giao',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: completeTheWork,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Text(
                                  ' III.3. Kết quả công việc có đóng góp cho cơ quan nơi thực tập',
                                  style: Style.subtitleStyle,
                                ),
                                CustomResultsEvaluation(
                                  controller: workResults,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                            TableRow(
                              decoration: const BoxDecoration(),
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'Cộng',
                                    style: Style.titleStyle,
                                  ),
                                ),
                                // Container(),
                                CustomResultsEvaluation(
                                  controller: sumController,
                                  lableText: null,
                                  icon: null,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '1. Nhận xét khác về sinh viên:',
                          style: Style.subtitleStyle,
                        ),
                        const SizedBox(height: 5),
                        TextFormReceipt(
                          controller: otherCommentsAboutStudents,
                          lableText: null,
                          icon: null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '2. Đánh giá của cơ quan về chương trình đào tạo (CTĐT): ',
                          style: Style.subtitleStyle,
                        ),
                        const SizedBox(height: 5),
                        CheckboxListTile(
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Phù hợp với thực tế'),
                          activeColor: primaryColor,
                          value: consistentWithReality,
                          onChanged: (bool? newValue) {
                            setState(() {
                              consistentWithReality = newValue;
                            });
                          },
                        ),
                        CheckboxListTile(
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Không phù hợp với thực tế'),
                          activeColor: primaryColor,
                          value: doesNotMatchReality,
                          onChanged: (bool? newValue) {
                            setState(() {
                              doesNotMatchReality = newValue;
                            });
                          },
                        ),
                        CheckboxListTile(
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Tăng cường kỹ năng mềm'),
                          activeColor: primaryColor,
                          value: enhanceSoftSkills,
                          onChanged: (bool? newValue) {
                            setState(() {
                              enhanceSoftSkills = newValue;
                            });
                          },
                        ),
                        CheckboxListTile(
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Tăng cường ngoại ngữ'),
                          activeColor: primaryColor,
                          value: strengThenForeignLanguages,
                          onChanged: (bool? newValue) {
                            setState(() {
                              strengThenForeignLanguages = newValue;
                            });
                          },
                        ),
                        CheckboxListTile(
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Tăng cường kỹ năng làm việc nhóm'),
                          activeColor: primaryColor,
                          value: enhanceTeamworkSkills,
                          onChanged: (bool? newValue) {
                            setState(() {
                              enhanceTeamworkSkills = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '3. Đề xuất góp ý của cơ quan về CTĐT:',
                          style: Style.subtitleStyle,
                        ),
                        const SizedBox(height: 5),
                        TextFormReceipt(
                          controller: suggestedComments,
                          lableText: null,
                          icon: null,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
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
                              // ResultEvaluation resultEvaluation =
                              //     ResultEvaluation(
                              //   implementTheRulesWell:
                              //       implementTheRulesWell.text,
                              //   complyWithWorkingHours:
                              //       complyWithWorkingHours.text,
                              //   attitude: attitude.text,
                              //   positiveInWork: positiveInWork.text,
                              //   meetJobRequirements: meetJobRequirements.text,
                              //   spiritOfLearning: spiritOfLearning.text,
                              //   haveSuggestions: haveSuggestions.text,
                              //   progressReport: progressReport.text,
                              //   completeTheWork: completeTheWork.text,
                              //   workResults: workResults.text,
                              //   sumScore: sumController.text,
                              //   otherCommentsAboutStudents:
                              //       otherCommentsAboutStudents.text,
                              //   consistentWithReality: consistentWithReality,
                              //   doesNotMatchReality: doesNotMatchReality,
                              //   enhanceSoftSkills: enhanceSoftSkills,
                              //   enhanceTeamworkSkills: enhanceTeamworkSkills,
                              //   strengThenForeignLanguages:
                              //       strengThenForeignLanguages,
                              //   suggestedComments: suggestedComments.text,
                              //   timestamp: Timestamp.now(),
                              // );
                              double implementTheRulesWellValue =
                                  double.tryParse(implementTheRulesWell.text) ??
                                      0;
                              double complyWithWorkingHoursValue =
                                  double.tryParse(
                                          complyWithWorkingHours.text) ??
                                      0;
                              double attitudeValue =
                                  double.tryParse(attitude.text) ?? 0;
                              double positiveInWorkValue =
                                  double.tryParse(positiveInWork.text) ?? 0;
                              double meetJobRequirementsValue =
                                  double.tryParse(meetJobRequirements.text) ??
                                      0;
                              double spiritOfLearningValue =
                                  double.tryParse(spiritOfLearning.text) ?? 0;
                              double haveSuggestionsValue =
                                  double.tryParse(haveSuggestions.text) ?? 0;
                              double progressReportValue =
                                  double.tryParse(progressReport.text) ?? 0;
                              double completeTheWorkValue =
                                  double.tryParse(completeTheWork.text) ?? 0;
                              double workResultsValue =
                                  double.tryParse(workResults.text) ?? 0;
                              double sumScore = implementTheRulesWellValue +
                                  complyWithWorkingHoursValue +
                                  attitudeValue +
                                  positiveInWorkValue +
                                  meetJobRequirementsValue +
                                  spiritOfLearningValue +
                                  haveSuggestionsValue +
                                  progressReportValue +
                                  completeTheWorkValue +
                                  workResultsValue;
                              // sumController.text = sumScore.toString();
                              sumController = TextEditingController(
                                  text: sumScore.toString());
                              String? idDKHP = await getAllDKHP(idStudent.text);
                              await FirebaseFirestore.instance
                                  .collection('DangKyHocPhan')
                                  .doc(idDKHP)
                                  .update({
                                'evaluation': true,
                              });
                              await FirebaseFirestore.instance
                                  .collection('ResultsEvaluation')
                                  .doc(idDocument)
                                  .update({
                                "implementTheRulesWell":
                                    implementTheRulesWell.text,
                                "complyWithWorkingHours":
                                    complyWithWorkingHours.text,
                                "attitude": attitude.text,
                                "positiveInWork": positiveInWork.text,
                                "meetJobRequirements": meetJobRequirements.text,
                                "spiritOfLearning": spiritOfLearning.text,
                                "haveSuggestions": haveSuggestions.text,
                                "progressReport": progressReport.text,
                                "completeTheWork": completeTheWork.text,
                                "workResults": workResults.text,
                                "sumScore": sumController.text,
                                "otherCommentsAboutStudents":
                                    otherCommentsAboutStudents.text,
                                "consistentWithReality": consistentWithReality,
                                "doesNotMatchReality": doesNotMatchReality,
                                "enhanceSoftSkills": enhanceSoftSkills,
                                "enhanceTeamworkSkills": enhanceTeamworkSkills,
                                "strengThenForeignLanguages":
                                    strengThenForeignLanguages,
                                "suggestedComments": suggestedComments.text,
                                "timestamp": Timestamp.now(),
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

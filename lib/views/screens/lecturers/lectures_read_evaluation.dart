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

class LectureReadResultsEvaluation extends StatefulWidget {
  const LectureReadResultsEvaluation({super.key});

  @override
  State<LectureReadResultsEvaluation> createState() =>
      _LectureReadResultsEvaluationState();
}

class _LectureReadResultsEvaluationState
    extends State<LectureReadResultsEvaluation> {
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
  TextEditingController suggestedComments = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Phiếu đánh giá kết quả'.toUpperCase(),
          style: Style.homeStyle,
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: resultsEvaluationFirestore,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
          TextEditingController nameCompanyController = TextEditingController(
              text: resultEvaluationList.companyIntern?.name);
          TextEditingController nameCanBoController = TextEditingController(
              text: resultEvaluationList.userCanBo?.userName);
          TextEditingController emailCanBoController = TextEditingController(
              text: resultEvaluationList.userCanBo?.email);
          TextEditingController phoneCanBoController = TextEditingController(
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
            workResults =
                TextEditingController(text: resultEvaluationList.workResults);
            completeTheWork = TextEditingController(
                text: resultEvaluationList.completeTheWork);
            otherCommentsAboutStudents = TextEditingController(
                text: resultEvaluationList.otherCommentsAboutStudents);
            suggestedComments = TextEditingController(
                text: resultEvaluationList.suggestedComments);
            consistentWithReality = resultEvaluationList.consistentWithReality;
            doesNotMatchReality = resultEvaluationList.doesNotMatchReality;
            enhanceSoftSkills = resultEvaluationList.enhanceSoftSkills;
            enhanceTeamworkSkills = resultEvaluationList.enhanceTeamworkSkills;
            strengThenForeignLanguages =
                resultEvaluationList.strengThenForeignLanguages;
            sumController =
                TextEditingController(text: resultEvaluationList.sumScore);
          }
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' đến'),
                          TextSpan(
                              text: ' 8/7/2023',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                      isReadOnly: true,
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
                      isReadOnly: true,
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
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:trungtamgiasu/constants/color.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/constants/style.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:trungtamgiasu/models/notification.dart';
import 'package:trungtamgiasu/models/notification_model.dart';
import 'package:trungtamgiasu/models/timeline_lecturers.dart';
import 'package:trungtamgiasu/models/timeline_mentor.dart';
import 'package:trungtamgiasu/models/timeline_student.dart';
import 'package:trungtamgiasu/services/firebase_api.dart';
import 'package:trungtamgiasu/views/screens/giaovu/home_giaovu_screen.dart';
import 'package:trungtamgiasu/views/screens/giaovu/widgets/button_management_time.dart';

class ManagementTime extends StatefulWidget {
  const ManagementTime({super.key});

  @override
  State<ManagementTime> createState() => _ManagementTimeState();
}

class _ManagementTimeState extends State<ManagementTime> {
  //Student
  String startDateRegisterCourseAndCompany = "Chưa đặt thời gian";
  String endDateRegisterCourseAndCompany = "";
  String startDateCheckReceiptAndAssignment = "Chưa đặt thời gian";
  String endDateCheckReceiptAndAssignment = "";
  String startDateStartIntern = "Chưa đặt thời gian";
  String endDateStartIntern = "";
  String startDateSubmitReport = "Chưa đặt thời gian";
  String endDateSubmitReport = "";
  String startDateHaveScore = "Chưa đặt thời gian";
  String endDateHaveScore = "";

  //Mentor
  String startDateAcceptStudent = "Chưa đặt thời gian";
  String endDateAcceptStudent = "";
  String startDateReceptAndAssignmentForm = "Chưa đặt thời gian";
  String endDateReceptAndAssignmentForm = "";
  String startDateEvaluationIntern = "Chưa đặt thời gian";
  String endDateEvaluationIntern = "";

  //Lecturers
  String startDateProcessIntern = "Chưa đặt thời gian";
  String endDateProcessIntern = "";
  String startDateLectureEvaluation = "Chưa đặt thời gian";
  String endDateLecturersEvaluation = "";

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  DateTimeRange selectionDate = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          children: [
            Text(
              'Quản lý mốc thời gian',
              style: Style.homeTitleStyle,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("ManagementTimeline")
                      .doc('sinhvien')
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
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

                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    TimelineStudentModel? timelineStudentModel =
                        TimelineStudentModel.fromJson(data);
                    if (timelineStudentModel
                            .courseRegisterAndCompany!.startDate !=
                        null) {
                      startDateRegisterCourseAndCompany = CurrencyFormatter()
                          .formattedDate(timelineStudentModel
                              .courseRegisterAndCompany!.startDate);
                      endDateRegisterCourseAndCompany = CurrencyFormatter()
                          .formattedDate(timelineStudentModel
                              .courseRegisterAndCompany!.endDate);
                    }
                    if (timelineStudentModel
                            .checkReceiptAndAssignment!.startDate !=
                        null) {
                      startDateCheckReceiptAndAssignment = CurrencyFormatter()
                          .formattedDate(timelineStudentModel
                              .checkReceiptAndAssignment!.startDate);
                      endDateCheckReceiptAndAssignment =
                          CurrencyFormatter().formattedDate(
                        timelineStudentModel.checkReceiptAndAssignment!.endDate,
                      );
                    }
                    if (timelineStudentModel.startIntern!.startDate != null) {
                      startDateStartIntern = CurrencyFormatter().formattedDate(
                        timelineStudentModel.startIntern!.startDate,
                      );
                      endDateStartIntern = CurrencyFormatter().formattedDate(
                        timelineStudentModel.startIntern!.endDate,
                      );
                    }
                    if (timelineStudentModel.submitReport!.startDate != null) {
                      startDateSubmitReport = CurrencyFormatter().formattedDate(
                        timelineStudentModel.submitReport!.startDate,
                      );
                      endDateSubmitReport = CurrencyFormatter().formattedDate(
                        timelineStudentModel.submitReport!.endDate,
                      );
                    }
                    if (timelineStudentModel.haveScore!.startDate != null) {
                      startDateHaveScore = CurrencyFormatter().formattedDate(
                        timelineStudentModel.haveScore!.startDate,
                      );
                      endDateHaveScore = CurrencyFormatter().formattedDate(
                        timelineStudentModel.haveScore!.endDate,
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sinh viên: ',
                          style: Style.hometitleStyle,
                        ),
                        CustomTimeline(
                          isFirst: true,
                          isLast: false,
                          isPast: true,
                          title: 'Đăng ký học phần & công ty',
                          time: startDateCheckReceiptAndAssignment !=
                                  "Chưa đặt thời gian"
                              ? '$startDateRegisterCourseAndCompany đến $endDateRegisterCourseAndCompany'
                              : startDateRegisterCourseAndCompany,
                          onTap: () async {
                            DateTimeRange selectionDate = DateTimeRange(
                              start: _startDate,
                              end: _endDate,
                            );
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                              initialDateRange: selectionDate,
                              fieldStartHintText: 'ngày/tháng/năm',
                              fieldEndHintText: 'ngày/tháng/năm',
                              locale: const Locale('vi', 'VI'),
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );
                            if (dateTimeRange != null) {
                              setState(
                                () {
                                  _startDate = dateTimeRange.start;
                                  _endDate = dateTimeRange.end;
                                  Timeline timeline = Timeline(
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  );
                                  TimelineStudentModel timelineStudent =
                                      TimelineStudentModel(
                                    id: 'sinhvien',
                                    courseRegisterAndCompany: timeline,
                                  );
                                  FirebaseFirestore.instance
                                      .collection("ManagementTimeline")
                                      .doc("sinhvien")
                                      .update({
                                    "courseRegisterAndCompany":
                                        timeline.toJson()
                                  }).then((_) {
                                    DateTime scheduledTime = _endDate
                                        .subtract(const Duration(days: 1))
                                        .add(const Duration(
                                            hours: 13,
                                            minutes: 16,
                                            seconds: 0));
                                    print(scheduledTime);
                                    Notifications notifications = Notifications(
                                      id: 'students',
                                      title:
                                          'Sắp hết thời gian đăng ký học phần & đăng ký công ty',
                                      body:
                                          'Thời gian đăng ký học phần & đăng ký công ty là đến hết ngày ${CurrencyFormatter().formattedDate(_endDate)}',
                                      timestamp: Timestamp.now(),
                                    );
                                    FirebaseApi.scheduleDailyNotification(
                                        scheduledTime, () {
                                      FirebaseApi()
                                          .sendFirebaseCloudMessage(
                                            notifications.title,
                                            notifications.body,
                                            'ef7LcJEeTvSqbPa1326AfA:APA91bE3PODJdPDjx4IRhrIA-q7paVWJkAVahvXsW0CnWly72c_0D5GBKZc-_299QKjDaodK_m1xkrkokMs3ujMW_KjnvF-kPRmmHdE-oC-HqNOcu4xRtFWX4UXI5ii_PSkDPvnuI5O3',
                                          )
                                          .then((_) => FirebaseFirestore
                                              .instance
                                              .collection("notifications")
                                              .add(notifications.toJson()));

                                      print(
                                          "Thông báo đã được gửi lúc $scheduledTime");
                                    });
                                    EasyLoading.showSuccess(
                                        'Đặt thời gian thành công !');
                                  });
                                },
                              );
                            }
                          },
                        ),
                        CustomTimeline(
                          isFirst: false,
                          isLast: false,
                          isPast: true,
                          title: 'Kiểm tra phiếu tiếp nhận & giao việc',
                          time: startDateCheckReceiptAndAssignment !=
                                  "Chưa đặt thời gian"
                              ? '$startDateCheckReceiptAndAssignment - $endDateCheckReceiptAndAssignment'
                              : startDateCheckReceiptAndAssignment,
                          onTap: () async {
                            DateTimeRange selectionDate = DateTimeRange(
                              start: _startDate,
                              end: _endDate,
                            );
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                              initialDateRange: selectionDate,
                              fieldStartHintText: 'ngày/tháng/năm',
                              fieldEndHintText: 'ngày/tháng/năm',
                              locale: const Locale('vi', 'VI'),
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );
                            if (dateTimeRange != null) {
                              setState(
                                () {
                                  _startDate = dateTimeRange.start;
                                  _endDate = dateTimeRange.end;
                                  Timeline timeline = Timeline(
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  );
                                  TimelineStudentModel timelineStudent =
                                      TimelineStudentModel(
                                    id: 'sinhvien',
                                    checkReceiptAndAssignment: timeline,
                                  );
                                  FirebaseFirestore.instance
                                      .collection("ManagementTimeline")
                                      .doc("sinhvien")
                                      .update({
                                    "checkReceiptAndAssignment":
                                        timeline.toJson()
                                  }).then(
                                    (_) => EasyLoading.showSuccess(
                                            'Đặt thời gian thành công !')
                                        .catchError(
                                      (error) {
                                        // Handle the error
                                        print(
                                            'Error while updating document: $error');
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        CustomTimeline(
                          isFirst: false,
                          isLast: false,
                          isPast: true,
                          title: 'Bắt đầu thực tập (8 tuần)',
                          time: startDateStartIntern != 'Chưa đặt thời gian'
                              ? '$startDateStartIntern đến $endDateStartIntern'
                              : startDateStartIntern,
                          onTap: () async {
                            DateTimeRange selectionDate = DateTimeRange(
                              start: _startDate,
                              end: _endDate,
                            );
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                              initialDateRange: selectionDate,
                              fieldStartHintText: 'ngày/tháng/năm',
                              fieldEndHintText: 'ngày/tháng/năm',
                              locale: const Locale('vi', 'VI'),
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );
                            if (dateTimeRange != null) {
                              setState(
                                () {
                                  _startDate = dateTimeRange.start;
                                  _endDate = dateTimeRange.end;
                                  Timeline timeline = Timeline(
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  );

                                  FirebaseFirestore.instance
                                      .collection("ManagementTimeline")
                                      .doc("sinhvien")
                                      .update({
                                    "startIntern": timeline.toJson()
                                  }).then(
                                    (_) => EasyLoading.showSuccess(
                                            'Đặt thời gian thành công !')
                                        .catchError(
                                      (error) {
                                        // Handle the error
                                        print(
                                            'Error while updating document: $error');
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        CustomTimeline(
                          isFirst: false,
                          isLast: false,
                          isPast: true,
                          title: 'Nộp báo cáo thực tập',
                          time: startDateSubmitReport != 'Chưa đặt thời gian'
                              ? '$startDateSubmitReport đến $endDateSubmitReport'
                              : startDateSubmitReport,
                          onTap: () async {
                            DateTimeRange selectionDate = DateTimeRange(
                              start: _startDate,
                              end: _endDate,
                            );
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                              initialDateRange: selectionDate,
                              fieldStartHintText: 'ngày/tháng/năm',
                              fieldEndHintText: 'ngày/tháng/năm',
                              locale: const Locale('vi', 'VI'),
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );
                            if (dateTimeRange != null) {
                              setState(
                                () {
                                  _startDate = dateTimeRange.start;
                                  _endDate = dateTimeRange.end;
                                  Timeline timeline = Timeline(
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  );

                                  FirebaseFirestore.instance
                                      .collection("ManagementTimeline")
                                      .doc("sinhvien")
                                      .update({
                                    "submitReport": timeline.toJson()
                                  }).then(
                                    (_) => EasyLoading.showSuccess(
                                            'Đặt thời gian thành công !')
                                        .catchError(
                                      (error) {
                                        // Handle the error
                                        print(
                                            'Error while updating document: $error');
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        CustomTimeline(
                          isFirst: false,
                          isLast: true,
                          isPast: true,
                          title: 'Giảng viên chấm và nhập điểm',
                          time: startDateHaveScore != 'Chưa đặt thời gian'
                              ? '$startDateHaveScore đến $endDateHaveScore'
                              : startDateHaveScore,
                          onTap: () async {
                            DateTimeRange selectionDate = DateTimeRange(
                              start: _startDate,
                              end: _endDate,
                            );
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                              initialDateRange: selectionDate,
                              fieldStartHintText: 'ngày/tháng/năm',
                              fieldEndHintText: 'ngày/tháng/năm',
                              locale: const Locale('vi', 'VI'),
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );
                            if (dateTimeRange != null) {
                              setState(
                                () {
                                  _startDate = dateTimeRange.start;
                                  _endDate = dateTimeRange.end;
                                  Timeline timeline = Timeline(
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  );

                                  FirebaseFirestore.instance
                                      .collection("ManagementTimeline")
                                      .doc("sinhvien")
                                      .update({
                                    "haveScore": timeline.toJson()
                                  }).then(
                                    (_) => EasyLoading.showSuccess(
                                            'Đặt thời gian thành công !')
                                        .catchError(
                                      (error) {
                                        // Handle the error
                                        print(
                                            'Error while updating document: $error');
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("ManagementTimeline")
                    .doc('canbohuongdan')
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
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
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    TimelineMentor? timelineMentor =
                        TimelineMentor.fromJson(data);
                    if (timelineMentor.acceptStudent!.startDate != null) {
                      startDateAcceptStudent = CurrencyFormatter()
                          .formattedDate(
                              timelineMentor.acceptStudent!.startDate);
                      endDateAcceptStudent = CurrencyFormatter()
                          .formattedDate(timelineMentor.acceptStudent!.endDate);
                    }
                    if (timelineMentor.receptAndAssignmentForm!.startDate !=
                        null) {
                      startDateReceptAndAssignmentForm = CurrencyFormatter()
                          .formattedDate(timelineMentor
                              .receptAndAssignmentForm!.startDate);
                      endDateReceptAndAssignmentForm =
                          CurrencyFormatter().formattedDate(
                        timelineMentor.receptAndAssignmentForm!.endDate,
                      );
                    }
                    if (timelineMentor.evaluationIntern!.startDate != null) {
                      startDateEvaluationIntern =
                          CurrencyFormatter().formattedDate(
                        timelineMentor.evaluationIntern!.startDate,
                      );
                      endDateEvaluationIntern =
                          CurrencyFormatter().formattedDate(
                        timelineMentor.evaluationIntern!.endDate,
                      );
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cán bộ hướng dẫn: ',
                        style: Style.hometitleStyle,
                      ),
                      CustomTimeline(
                        isFirst: true,
                        isLast: false,
                        isPast: true,
                        title: 'Xét duyệt sinh viên',
                        time: startDateAcceptStudent != "Chưa đặt thời gian"
                            ? '$startDateAcceptStudent đến $endDateAcceptStudent'
                            : startDateAcceptStudent,
                        onTap: () async {
                          DateTimeRange selectionDate = DateTimeRange(
                            start: _startDate,
                            end: _endDate,
                          );
                          final DateTimeRange? dateTimeRange =
                              await showDateRangePicker(
                            initialDateRange: selectionDate,
                            fieldStartHintText: 'ngày/tháng/năm',
                            fieldEndHintText: 'ngày/tháng/năm',
                            locale: const Locale('vi', 'VI'),
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                          );
                          if (dateTimeRange != null) {
                            setState(
                              () {
                                _startDate = dateTimeRange.start;
                                _endDate = dateTimeRange.end;
                                Timeline timeline = Timeline(
                                  startDate: _startDate,
                                  endDate: _endDate,
                                );
                                FirebaseFirestore.instance
                                    .collection("ManagementTimeline")
                                    .doc("canbohuongdan")
                                    .set({"acceptStudent": timeline.toJson()},
                                        SetOptions(merge: true)).then(
                                  (_) => EasyLoading.showSuccess(
                                          'Đặt thời gian thành công !')
                                      .catchError(
                                    (error) {
                                      // Handle the error
                                      print(
                                          'Error while updating document: $error');
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      CustomTimeline(
                        isFirst: false,
                        isLast: false,
                        isPast: true,
                        title: 'Lập phiếu tiếp nhận & giao việc',
                        time: startDateReceptAndAssignmentForm !=
                                "Chưa đặt thời gian"
                            ? '$startDateReceptAndAssignmentForm đến $endDateReceptAndAssignmentForm'
                            : startDateReceptAndAssignmentForm,
                        onTap: () async {
                          DateTimeRange selectionDate = DateTimeRange(
                            start: _startDate,
                            end: _endDate,
                          );
                          final DateTimeRange? dateTimeRange =
                              await showDateRangePicker(
                            initialDateRange: selectionDate,
                            fieldStartHintText: 'ngày/tháng/năm',
                            fieldEndHintText: 'ngày/tháng/năm',
                            locale: const Locale('vi', 'VI'),
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                          );
                          if (dateTimeRange != null) {
                            setState(
                              () {
                                _startDate = dateTimeRange.start;
                                _endDate = dateTimeRange.end;
                                Timeline timeline = Timeline(
                                  startDate: _startDate,
                                  endDate: _endDate,
                                );
                                FirebaseFirestore.instance
                                    .collection("ManagementTimeline")
                                    .doc("canbohuongdan")
                                    .set(
                                  {
                                    "receptAndAssignmentForm":
                                        timeline.toJson(),
                                  },
                                  SetOptions(merge: true),
                                ).then(
                                  (_) => EasyLoading.showSuccess(
                                          'Đặt thời gian thành công !')
                                      .catchError(
                                    (error) {
                                      // Handle the error
                                      print(
                                          'Error while updating document: $error');
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      CustomTimeline(
                        isFirst: false,
                        isLast: true,
                        isPast: true,
                        title: 'Đánh giá thực tập',
                        time: startDateEvaluationIntern != 'Chưa đặt thời gian'
                            ? '$startDateEvaluationIntern đến $endDateEvaluationIntern'
                            : startDateEvaluationIntern,
                        onTap: () async {
                          DateTimeRange selectionDate = DateTimeRange(
                            start: _startDate,
                            end: _endDate,
                          );
                          final DateTimeRange? dateTimeRange =
                              await showDateRangePicker(
                            initialDateRange: selectionDate,
                            fieldStartHintText: 'ngày/tháng/năm',
                            fieldEndHintText: 'ngày/tháng/năm',
                            locale: const Locale('vi', 'VI'),
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                          );
                          if (dateTimeRange != null) {
                            setState(
                              () {
                                _startDate = dateTimeRange.start;
                                _endDate = dateTimeRange.end;
                                Timeline timeline = Timeline(
                                  startDate: _startDate,
                                  endDate: _endDate,
                                );
                                FirebaseFirestore.instance
                                    .collection("ManagementTimeline")
                                    .doc("canbohuongdan")
                                    .set(
                                        {"evaluationIntern": timeline.toJson()},
                                        SetOptions(merge: true)).then(
                                  (_) => EasyLoading.showSuccess(
                                          'Đặt thời gian thành công !')
                                      .catchError(
                                    (error) {
                                      print(
                                          'Error while updating document: $error');
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("ManagementTimeline")
                      .doc('giangvien')
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
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
                    if (snapshot.hasData) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      TimelineLecturers? timelineMentor =
                          TimelineLecturers.fromJson(data);
                      if (timelineMentor.processIntern!.startDate != null) {
                        startDateProcessIntern = CurrencyFormatter()
                            .formattedDate(
                                timelineMentor.processIntern!.startDate);
                        endDateProcessIntern = CurrencyFormatter()
                            .formattedDate(
                                timelineMentor.processIntern!.endDate);
                      }
                      if (timelineMentor.evaluationIntern!.startDate != null) {
                        startDateLectureEvaluation = CurrencyFormatter()
                            .formattedDate(
                                timelineMentor.evaluationIntern!.startDate);
                        endDateLecturersEvaluation =
                            CurrencyFormatter().formattedDate(
                          timelineMentor.evaluationIntern!.endDate,
                        );
                      }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giảng viên: ',
                          style: Style.hometitleStyle,
                        ),
                        CustomTimeline(
                          isFirst: true,
                          isLast: false,
                          isPast: true,
                          title: 'Theo dõi tiến độ thực tập sinh viên',
                          time: startDateProcessIntern != "Chưa đặt thời gian"
                              ? '$startDateProcessIntern đến $endDateProcessIntern'
                              : startDateProcessIntern,
                          onTap: () async {
                            DateTimeRange selectionDate = DateTimeRange(
                              start: _startDate,
                              end: _endDate,
                            );
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                              initialDateRange: selectionDate,
                              fieldStartHintText: 'ngày/tháng/năm',
                              fieldEndHintText: 'ngày/tháng/năm',
                              locale: const Locale('vi', 'VI'),
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );
                            if (dateTimeRange != null) {
                              setState(
                                () {
                                  _startDate = dateTimeRange.start;
                                  _endDate = dateTimeRange.end;
                                  Timeline timeline = Timeline(
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  );
                                  FirebaseFirestore.instance
                                      .collection("ManagementTimeline")
                                      .doc("giangvien")
                                      .set({"processIntern": timeline.toJson()},
                                          SetOptions(merge: true)).then(
                                    (_) => EasyLoading.showSuccess(
                                            'Đặt thời gian thành công !')
                                        .catchError(
                                      (error) {
                                        // Handle the error
                                        print(
                                            'Error while updating document: $error');
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        CustomTimeline(
                          isFirst: false,
                          isLast: true,
                          isPast: true,
                          title: 'Đánh giá kết quả thực tập',
                          time: startDateLectureEvaluation !=
                                  "Chưa đặt thời gian"
                              ? '$startDateLectureEvaluation đến $endDateLecturersEvaluation'
                              : startDateLectureEvaluation,
                          onTap: () async {
                            DateTimeRange selectionDate = DateTimeRange(
                              start: _startDate,
                              end: _endDate,
                            );
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                              initialDateRange: selectionDate,
                              fieldStartHintText: 'ngày/tháng/năm',
                              fieldEndHintText: 'ngày/tháng/năm',
                              locale: const Locale('vi', 'VI'),
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );
                            if (dateTimeRange != null) {
                              setState(
                                () {
                                  _startDate = dateTimeRange.start;
                                  _endDate = dateTimeRange.end;
                                  Timeline timeline = Timeline(
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  );
                                  FirebaseFirestore.instance
                                      .collection("ManagementTimeline")
                                      .doc("giangvien")
                                      .set({
                                    "evaluationIntern": timeline.toJson()
                                  }, SetOptions(merge: true)).then(
                                    (_) => EasyLoading.showSuccess(
                                            'Đặt thời gian thành công !')
                                        .catchError(
                                      (error) {
                                        // Handle the error
                                        print(
                                            'Error while updating document: $error');
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTimeline extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String title;
  final String time;
  Function()? onTap;
  CustomTimeline({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.title,
    required this.time,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 65,
        child: TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          beforeLineStyle: const LineStyle(color: primaryColor),
          indicatorStyle: IndicatorStyle(
            width: 30,
            color: primaryColor,
            iconStyle: IconStyle(
              iconData: Icons.done,
              color: whiteColor,
            ),
          ),
          endChild: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.calendar_month,
                      color: primaryColor,
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      time,
                      style: Style.subtitleStyle.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

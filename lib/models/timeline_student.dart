import 'package:cloud_firestore/cloud_firestore.dart';

class TimelineStudentModel {
  String? id;
  Timeline? courseRegisterAndCompany;
  Timeline? checkReceiptAndAssignment;
  Timeline? startIntern;
  Timeline? submitReport;
  Timeline? haveScore;
  String? typeUser;

  TimelineStudentModel({
    this.id,
    this.courseRegisterAndCompany,
    this.checkReceiptAndAssignment,
    this.startIntern,
    this.submitReport,
    this.haveScore,
    this.typeUser,
  });

  factory TimelineStudentModel.fromJson(Map<String, dynamic>? json) =>
      TimelineStudentModel(
        id: json?["id"],
        courseRegisterAndCompany:
            Timeline.fromJson(json?["courseRegisterAndCompany"]),
        checkReceiptAndAssignment:
            Timeline.fromJson(json?["checkReceiptAndAssignment"]),
        startIntern: Timeline.fromJson(json?["startIntern"]),
        submitReport: Timeline.fromJson(json?["submitReport"]),
        haveScore:  Timeline.fromJson(json?['haveScore']),
        typeUser: json?["typeUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "courseRegisterAndCompany": courseRegisterAndCompany?.toJson(),
        "checkReceiptAndAssignment": checkReceiptAndAssignment?.toJson(),
        "startIntern": startIntern?.toJson(),
        "submitReport": submitReport?.toJson(),
        "haveScore": haveScore?.toJson,
        "typeUser": typeUser,
      };
}

class Timeline {
  DateTime? startDate;
  DateTime? endDate;
  Timeline({
    this.startDate,
    this.endDate,
  });
  factory Timeline.fromJson(Map<String, dynamic>? json) => Timeline(
        startDate: _parseDateTime(json?['startDate']),
        endDate: _parseDateTime(json?['endDate']),
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate,
        "endDate": endDate,
      };
  static DateTime? _parseDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    } else if (value is Timestamp) {
      return value.toDate();
    } else {
      return null;
    }
  }
}

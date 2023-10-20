import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/models/work_content.dart';

class AssignmentSlip {
  UserModel? userCanBo;
  String? id;
  final TextEditingController nameCompanyController;
  final TextEditingController nameCanBoController;
  final TextEditingController nameStudentController;
  final TextEditingController mssvController;
  final List<WorkContent>? workContentControllers;
  // final List<TextEditingController> weekNumberControllers;
  final Timestamp? dateTime;

  AssignmentSlip({
    this.dateTime,
    this.userCanBo,
    this.id,
    required this.nameCompanyController,
    required this.nameCanBoController,
    required this.nameStudentController,
    required this.mssvController,
    this.workContentControllers,
    // this.weekNumberControllers,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'userCanBo': userCanBo
          ?.toMap(), // Assuming UserModel and CompanyIntern also have toMap methods
      'id': id,
      'nameCompanyController': nameCompanyController.text,
      'nameCanBoController': nameCanBoController.text,
      'nameStudentController': nameStudentController.text,
      'mssvController': mssvController.text,
      'workContentControllers': workContentControllers
          ?.map((workContent) => workContent.toMap())
          .toList(),
      //   'weekNumberControllers':
      //       weekNumberControllers.map((controller) => controller.text).toList(),
    };
  }

  factory AssignmentSlip.fromMap(Map<String, dynamic> map) {
    return AssignmentSlip(
      dateTime: map["dateTime"],
      userCanBo: UserModel.fromMap(map['userCanBo']),
      id: map["id"],
      nameCompanyController:
          TextEditingController(text: map['nameCompanyController']),
      nameCanBoController:
          TextEditingController(text: map['nameCanBoController']),
      nameStudentController:
          TextEditingController(text: map['nameStudentController']),
      mssvController: TextEditingController(text: map['mssvController']),
      workContentControllers: (map['workContentControllers'] as List<dynamic>)
          .map((workContentMap) =>
              WorkContent.fromMap(workContentMap as Map<String, dynamic>))
          .toList(),
    );
  }
}

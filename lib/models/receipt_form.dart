import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';

class ReceiptForm {
  String? id;
  Timestamp? timestamp;
  bool? isWorkRoomSelected1;
  bool? isComputerSelected2;
  bool? isWorkOnlineSelected = false;
  bool? isSalarySelected2 = false;
  UserModel? userStudent;
  CompanyIntern? companyIntern;
  String? hourPerDay;
  String? dayPerWeek;
  String? workContent;
  UserModel? userCanBo;

  ReceiptForm({
    this.isSalarySelected2,
    this.isWorkOnlineSelected,
    this.timestamp,
    this.id,
    this.isWorkRoomSelected1,
    this.isComputerSelected2,
    this.companyIntern,
    this.userStudent,
    this.hourPerDay,
    this.dayPerWeek,
    this.workContent,
    this.userCanBo,
  });

  // Convert a Map to a ReceiptForm object
  factory ReceiptForm.fromMap(Map<String, dynamic> map) {
    return ReceiptForm(
      isSalarySelected2: map['isSalarySelected2'],
      isWorkOnlineSelected: map['isWorkOnlineSelected'],
      timestamp: map['timestamp'],
      id: map['id'],
      isWorkRoomSelected1: map['isWorkRoomSelected1'],
      isComputerSelected2: map['isComputerSelected2'],
      userStudent: UserModel.fromMap(map['userStudent']),
      companyIntern: CompanyIntern.fromMap(map['companyIntern']),
      hourPerDay: map['hourPerDay'],
      dayPerWeek: map['dayPerWeek'],
      workContent: map['workContent'],
      userCanBo: UserModel.fromMap(map['userCanBo']),
    );
  }

  // Convert a ReceiptForm object to a Map
  Map<String, dynamic> toMap() {
    return {
      "isWorkOnlineSelected": isWorkOnlineSelected,
      "isSalarySelected2": isSalarySelected2,
      "timestamp": timestamp,
      'id': id,
      'isWorkRoomSelected1': isWorkRoomSelected1,
      'isComputerSelected2': isComputerSelected2,
      'userStudent': userStudent
          ?.toMap(), // Assuming UserModel and CompanyIntern also have toMap methods
      'companyIntern': companyIntern?.toMap(),
      'hourPerDay': hourPerDay,
      'dayPerWeek': dayPerWeek,
      'workContent': workContent,
      'userCanBo': userCanBo?.toMap(),
    };
  }
}

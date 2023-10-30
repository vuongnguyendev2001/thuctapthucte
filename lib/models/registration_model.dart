import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/models/user/user_student_model.dart';

class RegistrationModel {
  String? id;
  CompanyIntern Company;
  UserModel user;
  String status;
  String nameCV;
  String urlCV;
  Timestamp? timestamp;
  String positionApply;
  String idDKHP;

  RegistrationModel({
    this.timestamp,
    required this.nameCV,
    required this.urlCV,
    this.id,
    required this.Company,
    required this.user,
    required this.status,
    required this.positionApply,
    required this.idDKHP
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'Company': Company.toMap(),
      'user': user.toMap(),
      'status': status,
      'url': urlCV,
      'name': nameCV,
      'positionApply': positionApply,
      'idDKHP': idDKHP
    };
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    return RegistrationModel(
      timestamp: map['timestamp'],
      id: map['id'],
      Company: CompanyIntern.fromMap(map['Company']),
      user: UserModel.fromMap(map['user']), // Tạo UserModel từ Map
      status: map['status'],
      nameCV: map['name'],
      urlCV: map['url'],
      positionApply: map['positionApply'],
      idDKHP: map['idDKHP'],
    );
  }
}

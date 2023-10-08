import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';
import 'package:trungtamgiasu/models/user/user_student_model.dart';

class RegistrationModel {
  String id;
  CompanyIntern Company;
  UserModel user;
  String status;
  String nameCV;
  String urlCV;

  RegistrationModel({
    required this.nameCV,
    required this.urlCV,
    required this.id,
    required this.Company,
    required this.user,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Company': Company.toMap(),
      'user': user.toMap(),
      'status': status,
      'url': urlCV,
      'name': nameCV,
    };
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    return RegistrationModel(
      id: map['id'],
      Company: CompanyIntern.fromMap(map['Company']),
      user: UserModel.fromMap(map['user']), // Tạo UserModel từ Map
      status: map['status'],
      nameCV: map['name'],
      urlCV: map['url'],
    );
  }
}

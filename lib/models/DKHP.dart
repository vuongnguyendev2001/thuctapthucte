import 'package:trungtamgiasu/models/user/user_model.dart';

class DangKyHocPhan {
  String? idDKHP; // ID của đăng ký học phần
  String idHK; // ID của học kỳ
  String idHP;
  String? idGiangVien; // ID của học phần
  UserModel user;
  bool? locationIntern;
  bool? receiptForm;
  bool? assignmentSlipForm;
  bool? evaluation;

  DangKyHocPhan({
    this.idGiangVien,
    this.idDKHP,
    required this.idHK,
    required this.idHP,
    required this.user,
    this.locationIntern,
    this.receiptForm,
    this.assignmentSlipForm,
    this.evaluation,
  });

  factory DangKyHocPhan.fromMap(Map<String, dynamic> map) {
    return DangKyHocPhan(
      idGiangVien: map['idGiangVien'],
      idDKHP: map['idDKHP'],
      idHK: map['idHK'],
      idHP: map['idHP'],
      user: UserModel.fromMap(map['user']),
      locationIntern: map['locationIntern'],
      receiptForm: map['receiptForm'],
      assignmentSlipForm: map['assignmentSlipForm'],
      evaluation: map['evaluation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idGiangVien': idGiangVien,
      'idDKHP': idDKHP,
      'idHK': idHK,
      'idHP': idHP,
      'user': user.toMap(),
      'locationIntern': locationIntern,
      'receiptForm': receiptForm,
      'assignmentSlipForm': assignmentSlipForm,
      'evaluation': evaluation
    };
  }
}

import 'package:trungtamgiasu/models/user/user_model.dart';

class DangKyHocPhan {
  String idDKHP;  // ID của đăng ký học phần
  String idHK;    // ID của học kỳ
  String idHP;    // ID của học phần
  UserModel user; // Thông tin người đăng ký

  DangKyHocPhan({
    required this.idDKHP,
    required this.idHK,
    required this.idHP,
    required this.user,
  });

  factory DangKyHocPhan.fromMap(Map<String, dynamic> map) {
    return DangKyHocPhan(
      idDKHP: map['idDKHP'],
      idHK: map['idHK'],
      idHP: map['idHP'],
      user: UserModel.fromMap(map['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idDKHP': idDKHP,
      'idHK': idHK,
      'idHP': idHP,
      'user': user.toMap(),
    };
  }
}
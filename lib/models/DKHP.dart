import 'package:trungtamgiasu/models/lecturers_evaluation_model.dart';
import 'package:trungtamgiasu/models/pdf_model.dart';
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
  LecturersEvaluation? lecturersEvaluation;
  bool? isSubmitReport;
  ReportPdfViewer? submitReport;

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
    this.lecturersEvaluation,
    this.submitReport,
    this.isSubmitReport,
  });

  factory DangKyHocPhan.fromMap(Map<String, dynamic> map) {
    return DangKyHocPhan(
      idGiangVien: map['idGiangVien'] ?? '',
      idDKHP: map['idDKHP'] ?? '',
      idHK: map['idHK'] ?? '',
      idHP: map['idHP'] ?? '',
      user: UserModel.fromMap(map['user'] ?? ''),
      locationIntern: map['locationIntern'] ?? '',
      receiptForm: map['receiptForm'] ?? '',
      assignmentSlipForm: map['assignmentSlipForm'] ?? '',
      evaluation: map['evaluation'] ?? '',
      lecturersEvaluation: map['lecturersEvaluation'] != null
          ? LecturersEvaluation.fromMap(map['lecturersEvaluation'])
          : null,
      submitReport: map['submitReport'] != null
          ? ReportPdfViewer.fromMap(map['submitReport'])
          : null,
      isSubmitReport:
          map['isSubmitReport'], // Create LecturersEvaluation if not null
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
      'evaluation': evaluation,
      'lecturersEvaluation': lecturersEvaluation?.toMap(),
      'submitReport': submitReport?.toMap(),
      'isSubmitReport': isSubmitReport
    };
  }
}

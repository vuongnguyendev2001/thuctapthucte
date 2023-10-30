import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';

class PdfViewerArguments {
  final String urlCV;
  final String title;

  PdfViewerArguments(this.urlCV, this.title);
}

class ReportPdfViewer {
  final String urlReport;
  final String titleReport;

  ReportPdfViewer(this.urlReport, this.titleReport);

  Map<String, dynamic> toMap() {
    return {
      'urlReport': urlReport,
      'titleReport': titleReport,
    };
  }

  factory ReportPdfViewer.fromMap(Map<String, dynamic> map) {
    return ReportPdfViewer(
      map['urlReport'] as String,
      map['titleReport'] as String,
    );
  }
}

class RegisterViewerArguments {
  final UserModel userModel;
  final CompanyIntern companyIntern;
  String? idHK;

  RegisterViewerArguments(this.userModel, this.companyIntern, this.idHK);
}

class SinhVienDaDangKyThucTapArguments {
  final String idHocKiNamHoc;
  final String idAllHocPhan;

  SinhVienDaDangKyThucTapArguments(
    this.idHocKiNamHoc,
    this.idAllHocPhan,
  );
}

class sumScoreAndIdDocParameters {
  final String sumScoreCanBo;
  final String idDKHP;
  final String fcmTokenStudent;
  final String emailStudent;
  sumScoreAndIdDocParameters(
    this.sumScoreCanBo,
    this.idDKHP,
    this.fcmTokenStudent,
    this.emailStudent,
  );
}

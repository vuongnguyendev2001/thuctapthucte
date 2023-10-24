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

  RegisterViewerArguments(this.userModel, this.companyIntern);
}

class SinhVienDaDangKyThucTapArguments{
  final String idHocKiNamHoc;
  final String idAllHocPhan;

  SinhVienDaDangKyThucTapArguments(
    this.idHocKiNamHoc,
    this.idAllHocPhan,
  );
}
class sumScoreAndIdDocParameters{
  final String sumScoreCanBo;
  final String idDKHP;

  sumScoreAndIdDocParameters(
    this.sumScoreCanBo,
    this.idDKHP,
  );
}

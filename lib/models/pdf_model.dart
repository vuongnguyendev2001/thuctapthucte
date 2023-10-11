import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';

class PdfViewerArguments {
  final String urlCV;
  final String title;

  PdfViewerArguments(this.urlCV, this.title);
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

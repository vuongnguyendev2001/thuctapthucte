class HocPhan {
  String? id;
  String? idHocKi;
  String maHocPhan;
  String tenHocPhan;
  String lop;
  String giaoVien;
  String kyHieu;

  HocPhan(
    this.id,
    this.idHocKi,
    this.maHocPhan,
    this.tenHocPhan,
    this.lop,
    this.giaoVien,
    this.kyHieu, // Thêm trường ký hiệu
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idHocKi': idHocKi,
      'maHocPhan': maHocPhan,
      'tenHocPhan': tenHocPhan,
      'lop': lop,
      'giaoVien': giaoVien,
      'kyHieu': kyHieu,
    };
  }

  factory HocPhan.fromMap(Map<String, dynamic> map) {
    return HocPhan(
      map['id'],
      map['idHocKi'],
      map['maHocPhan'],
      map['tenHocPhan'],
      map['lop'],
      map['giaoVien'],
      map['kyHieu'],
    );
  }
}

List<Map<String, dynamic>> jsonHocPhanData = [
  {
    "maHocPhan": "CT472",
    "tenHocPhan": "Thực tập thực tế - HTTT",
    "lop": "K46",
    "kyHieu": "01",
    "giaoVien": "Nguyễn Thái Nghe"
  },
  {
    "maHocPhan": "CT472",
    "tenHocPhan": "Thực tập thực tế - HTTT",
    "lop": "DI1995A1",
    "kyHieu": "02",
    "giaoVien": "Phạm Thị Ngọc Diễm"
  },
  {
    "maHocPhan": "CT472",
    "tenHocPhan": "Thực tập thực tế - HTTT",
    "lop": "DI1995A2",
    "kyHieu": "03",
    "giaoVien": "Nguyễn Thanh Hải"
  },
  {
    "maHocPhan": "CT473",
    "tenHocPhan": "Thực tập thực tế - KHMT",
    "lop": "K46",
    "kyHieu": "01",
    "giaoVien": "Phạm Xuân Hiền"
  },
  {
    "maHocPhan": "CT473",
    "tenHocPhan": "Thực tập thực tế - KHMT",
    "lop": "DI19Z6A1",
    "kyHieu": "02",
    "giaoVien": "Phạm Nguyên Hoàng"
  },
  {
    "maHocPhan": "CT473",
    "tenHocPhan": "Thực tập thực tế - KHMT",
    "lop": "DI19Z6A2",
    "kyHieu": "03",
    "giaoVien": "Trần Việt Châu"
  }
];

List<HocPhan> convertJsonToHocPhanList(List<Map<String, dynamic>> jsonData) {
  return jsonData.map((map) => HocPhan.fromMap(map)).toList();
}

class InternshipApplication {
  String? id; // ID của đơn đăng ký (có thể được Firebase tạo tự động)
  String? idCompanies; // ID của công ty
  String? idUser; // ID của người dùng (sinh viên)
  String?
      status; // Trạng thái đăng ký (ví dụ: Đang duyệt, Đã duyệt, Bị từ chối)

  InternshipApplication({
    this.id,
    this.idCompanies,
    this.idUser,
    this.status,
  });

  // Hàm tạo đối tượng từ một Map (để tải dữ liệu từ Firestore)
  factory InternshipApplication.fromMap(Map<String, dynamic> map) {
    return InternshipApplication(
      id: map['id'],
      idCompanies: map['idCompanies'],
      idUser: map['idUser'],
      status: map['status'],
    );
  }

  // Hàm chuyển đổi đối tượng thành một Map (để lưu vào Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCompanies': idCompanies,
      'idUser': idUser,
      'status': status,
    };
  }
}

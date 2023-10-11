import 'package:trungtamgiasu/models/hoc_phan.dart';

class CourseRegistration {
  String? id;
  String semester;
  String academicYear; // Sử dụng List<HocPhan> thay vì HocPhan?

  CourseRegistration({
    required this.id,
    required this.semester,
    required this.academicYear, // Sửa tên thuộc tính thành hocPhan
  });

  factory CourseRegistration.fromMap(Map<String, dynamic> json) {
    return CourseRegistration(
      semester: json['semester'],
      academicYear: json['academicYear'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'semester': semester,
      'academicYear': academicYear,
    };
  }
}

List<Map<String, dynamic>> jsonCourseRegistrationData = [
  {
    "semester": "Hè",
    "academicYear": "2023-2024",
  },
  {
    "semester": "Hè",
    "academicYear": "2024-2025",
  },
  {
    "semester": "Hè",
    "academicYear": "2025-2026",
  }
];

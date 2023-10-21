import 'package:trungtamgiasu/models/course_register.dart';

class UserModel {
  String? avatar;
  String? uid;
  String? userName;
  String? email;
  String? phoneNumber;
  String? address;
  String? type;
  String? idCompany;
  String? idClass;
  String? major;
  String? MSSV;
  String? MSCB;
  String? phoneNumberCompany;
  String? phoneNumberCanBo;
  // CourseRegistration? courseRegistration;
  UserModel({
    this.idCompany,
    this.uid,
    this.email,
    this.userName,
    this.avatar,
    this.phoneNumber,
    this.address,
    this.type,
    this.MSSV,
    this.MSCB,
    this.idClass,
    this.major,
    this.phoneNumberCanBo,
    this.phoneNumberCompany,
    // this.courseRegistration,
  });
  factory UserModel.fromMap(map) {
    return UserModel(
      MSCB: map['MSCB'],
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      avatar: map['avatar'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      type: map['type'],
      idCompany: map['idCompany'],
      MSSV: map['MSSV'],
      idClass: map['idClass'],
      major: map['major'],
      phoneNumberCanBo: map['phoneNumberCanBo'],
      phoneNumberCompany: map['phoneNumberCompany'],
      // courseRegistration: map['courseRegistration'] != null
      //     ? CourseRegistration.fromMap(map['courseRegistration'])
      //     : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
      'address': address,
      'type': type,
      'idCompany': idCompany,
      'MSSV': MSSV,
      'MSCB': MSCB,
      'idClass': idClass,
      'major': major,
      'phoneNumberCanBo': phoneNumberCanBo,
      'phoneNumberCompany': phoneNumberCompany,
      // 'courseRegistration': courseRegistration!.toMap(),
    };
  }
}

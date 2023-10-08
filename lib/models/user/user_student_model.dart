class UserStudentModel {
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
  UserStudentModel({
    this.idCompany,
    this.uid,
    this.email,
    this.userName,
    this.avatar,
    this.phoneNumber,
    this.address,
    this.type,
  });
  factory UserStudentModel.fromMap(map) {
    return UserStudentModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      avatar: map['avatar'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      type: map['type'],
      idCompany: map['idCompany'],
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
    };
  }
}

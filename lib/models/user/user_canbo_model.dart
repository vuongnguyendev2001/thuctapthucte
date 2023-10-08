class UserCanBoModel {
  String? avatar;
  String? uid;
  String? userName;
  String? email;

  String? address;
  String? type;
  String? idCompany;
  String? phoneNumberCompany;
  String? phoneNumberCanBo;

  UserCanBoModel(
      {this.idCompany,
      this.uid,
      this.email,
      this.userName,
      this.avatar,
      this.phoneNumberCompany,
      this.phoneNumberCanBo,
      this.address,
      this.type});
  factory UserCanBoModel.fromMap(map) {
    return UserCanBoModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      avatar: map['avatar'],
      phoneNumberCompany: map['phoneNumberCompany'],
      phoneNumberCanBo: map['phoneNumberCanBo'],
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
      'phoneNumberCanBo': phoneNumberCanBo,
      'phoneNumberCompany': phoneNumberCompany,
      'address': address,
      'type': type,
      'idCompany': idCompany,
    };
  }
}

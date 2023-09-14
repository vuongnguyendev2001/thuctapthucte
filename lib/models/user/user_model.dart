class UserModel {
  String? avatar;
  String? uid;
  String? userName;
  String? email;
  String? phoneNumber;
  String? address;
  String? type;
  UserModel(
      {this.uid,
      this.email,
      this.userName,
      this.avatar,
      this.phoneNumber,
      this.address,
      this.type});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      avatar: map['avatar'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      type: map['type'],
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
      'type': type
    };
  }
}

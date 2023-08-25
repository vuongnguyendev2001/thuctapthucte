import 'dart:convert';

class CustomerInfo {
  CustomerInfo({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.domainId,
    this.createdBy,
    this.token,
    this.cmFirebaseToken,
    this.walletBalance,
    this.totalPoint,
    this.curentPoint,
    this.createdAt,
    this.updatedAt,
    this.emailVerifiedAt,
    this.emailVerified,
    this.status,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  int? domainId;
  int? createdBy;
  String? token;
  String? cmFirebaseToken;
  num? walletBalance;
  num? totalPoint;
  num? curentPoint;
  String? createdAt;
  String? updatedAt;
  String? emailVerifiedAt;
  int? emailVerified;
  int? status;

  CustomerInfo copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? domainId,
    int? createdBy,
    String? token,
    String? cmFirebaseToken,
    num? walletBalance,
    num? totalPoint,
    num? curentPoint,
    String? createdAt,
    String? updatedAt,
    String? emailVerifiedAt,
    int? emailVerified,
    int? status,
  }) =>
      CustomerInfo(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        domainId: domainId ?? this.domainId,
        createdBy: createdBy ?? this.createdBy,
        token: token ?? this.token,
        cmFirebaseToken: cmFirebaseToken ?? this.cmFirebaseToken,
        walletBalance: walletBalance ?? this.walletBalance,
        totalPoint: totalPoint ?? this.totalPoint,
        curentPoint: curentPoint ?? this.curentPoint,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        emailVerified: emailVerified ?? this.emailVerified,
        status: status ?? this.status,
      );

  factory CustomerInfo.fromRawJson(String str) =>
      CustomerInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        domainId: json["domain_id"],
        createdBy: json["created_by"],
        token: json["token"],
        cmFirebaseToken: json["cm_firebase_token"],
        walletBalance: json["wallet_balance"],
        totalPoint: json["total_point"],
        curentPoint: json["curent_point"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        emailVerifiedAt: json["email_verified_at"],
        emailVerified: json["email_verified"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "domain_id": domainId,
        "created_by": createdBy,
        "token": token,
        "cm_firebase_token": cmFirebaseToken,
        "wallet_balance": walletBalance,
        "total_point": totalPoint,
        "curent_point": curentPoint,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "email_verified_at": emailVerifiedAt,
        "email_verified": emailVerified,
        "status": status,
      };
}

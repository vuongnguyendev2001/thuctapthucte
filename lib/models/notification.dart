import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String? id;
  String? title;
  String? body;
  Timestamp? timestamp;
  String? emailUser;
  String? urlFile;
  String? nameFile;

  Notifications({
    this.id,
    this.title,
    this.body,
    this.timestamp,
    this.emailUser,
    this.urlFile,
    this.nameFile,
  });

  factory Notifications.fromJson(Map<String, dynamic>? json) {
    return Notifications(
      id: json!["id"] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      timestamp: json['timestamp'] ?? '',
      emailUser: json['emailUser'] ?? '',
      urlFile: json['urlFile'] ?? '',
      nameFile: json['nameFile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp,
      'emailUser': emailUser,
      'urlFile': urlFile,
      'nameFile': nameFile,
    };
  }
}

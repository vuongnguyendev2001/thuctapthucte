import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  final String title;
  final String body;
  final Timestamp timestamp;
  final String emailUser;

  Notifications({
    required this.title,
    required this.body,
    required this.timestamp,
    required this.emailUser
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      title: json['title'],
      body: json['body'],
      timestamp: json['timestamp'],
      emailUser: json['emailUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp,
      'emailUser': emailUser
    };
  }
}

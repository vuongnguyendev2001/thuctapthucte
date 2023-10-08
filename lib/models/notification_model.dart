class NotificationModel {
  final String id; // ID của thông báo
  final String userId; // ID của người dùng
  final String title; // Tiêu đề thông báo
  final String body; // Nội dung thông báo
  final DateTime timestamp; // Thời gian thông báo được tạo

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'] as int,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

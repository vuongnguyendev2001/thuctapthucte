import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trungtamgiasu/constants/currency_formatter.dart';
import 'package:trungtamgiasu/controllers/route_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage message) {
    // ignore: unnecessary_null_comparison
    if (message == null) return;
    Get.toNamed(
      RouteManager.notificationStudent,
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(message);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    initPushNotifications();
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Title: ${message.notification?.body}');
    print('Title: ${message.data}');
  }

  Future<void> sendFirebaseCloudMessage(
      String? title, String? body, String? fCMTokenUser) async {
    const adminEmail = 'tma@gmail.com';
    final fCMToken = await _firebaseMessaging.getToken();
    const String serverKey =
        'AAAAtDyOrRA:APA91bHKyZ3f1qsilnShunaN2Qb_rlLSZEIYrth9R6ZcQINCF98h4SZuu74BZJ6LJ0zE82-vN8fX94mXG60S128av71bAQqrSpH5CsWhK2Ua8QKwb_iBbMZ5E_sjrSvQHxXDJu_Rdq0E'; // Thay YOUR_SERVER_KEY bằng server key của bạn từ Firebase Console

    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    String? timeNotification =
        CurrencyFormatter().formattedDatebook(Timestamp.now());
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };
    final Map<String, dynamic> data = {
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'timestamp': timeNotification,
      },
      'to': fCMTokenUser,
    };

    final String jsonData = jsonEncode(data);

    try {
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print('Thành công: ${response.body}');
      } else {
        print('Lỗi: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Lỗi: $error');
    }
  }
}

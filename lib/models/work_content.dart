import 'package:flutter/cupertino.dart';

class WorkContent {
  final TextEditingController weekNumberController;
  final TextEditingController sessionNumberController;
  final TextEditingController workContentDetailController;
  TextEditingController? trackingWorkContentDetailController;

  WorkContent({
    this.trackingWorkContentDetailController,
    required this.weekNumberController,
    required this.sessionNumberController,
    required this.workContentDetailController,
  });

  factory WorkContent.fromMap(Map<String, dynamic> map) {
    return WorkContent(
      trackingWorkContentDetailController:
          TextEditingController(text: map['trackingWorkContent'] ?? ''),
      weekNumberController:
          TextEditingController(text: map['weekNumber'] ?? ''),
      sessionNumberController:
          TextEditingController(text: map['sessionNumber'] ?? ''),
      workContentDetailController:
          TextEditingController(text: map['workContentDetail'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackingWorkContent': trackingWorkContentDetailController?.text,
      'weekNumber': weekNumberController.text,
      'sessionNumber': sessionNumberController.text,
      'workContentDetail': workContentDetailController.text,
    };
  }
}

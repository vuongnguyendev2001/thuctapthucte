import 'package:trungtamgiasu/models/timeline_student.dart';

class TimelineLecturers {
  String? id;
  Timeline? processIntern;
  Timeline? evaluationIntern;
  String? typeUser;

  TimelineLecturers({
    this.id,
    this.processIntern,
    this.evaluationIntern,
    this.typeUser,
  });

  factory TimelineLecturers.fromJson(Map<String, dynamic>? json) =>
      TimelineLecturers(
        id: json?["id"],
        processIntern: Timeline.fromJson(json?["processIntern"]),
        evaluationIntern: Timeline.fromJson(json?["evaluationIntern"]),
        typeUser: json?["typeUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "processIntern": processIntern!.toJson(),
        "evaluationIntern": evaluationIntern!.toJson(),
        "typeUser": typeUser,
      };
}

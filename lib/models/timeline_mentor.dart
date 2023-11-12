import 'package:trungtamgiasu/models/timeline_student.dart';

class TimelineMentor {
  String? id;
  Timeline? acceptStudent;
  Timeline? receptAndAssignmentForm;
  Timeline? evaluationIntern;
  String? typeUser;

  TimelineMentor({
    this.id,
    this.acceptStudent,
    this.receptAndAssignmentForm,
    this.evaluationIntern,
    this.typeUser,
  });

  factory TimelineMentor.fromJson(Map<String, dynamic>? json) => TimelineMentor(
        id: json?["id"],
        acceptStudent: Timeline.fromJson(json?["acceptStudent"]),
        receptAndAssignmentForm:
            Timeline.fromJson(json?["receptAndAssignmentForm"]),
        evaluationIntern: Timeline.fromJson(json?["evaluationIntern"]),
        typeUser: json?["typeUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "acceptStudent": acceptStudent?.toJson(),
        "receptAndAssignmentForm": receptAndAssignmentForm?.toJson(),
        "evaluationIntern": evaluationIntern?.toJson(),
        "typeUser": typeUser,
      };
}

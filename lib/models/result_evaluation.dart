import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trungtamgiasu/models/company_intern.dart';
import 'package:trungtamgiasu/models/user/user_model.dart';

class ResultEvaluation {
  String? id;
  Timestamp? timestamp;
  Timestamp? startDay;
  Timestamp? endDay;
  UserModel? userStudent;
  CompanyIntern? companyIntern;
  UserModel? userCanBo;
  bool? consistentWithReality;
  bool? doesNotMatchReality;
  bool? enhanceSoftSkills = false;
  bool? strengThenForeignLanguages = false;
  bool? enhanceTeamworkSkills = false;
  String? otherCommentsAboutStudents;
  String? suggestedComments;
  String? implementTheRulesWell;
  String? complyWithWorkingHours;
  String? attitude;
  String? positiveInWork;
  String? meetJobRequirements;
  String? spiritOfLearning;
  String? haveSuggestions;
  String? progressReport;
  String? completeTheWork;
  String? workResults;
  String? sumScore;
  String? idHK;

  ResultEvaluation({
    this.sumScore,
    this.id,
    this.timestamp,
    this.startDay,
    this.endDay,
    this.userStudent,
    this.companyIntern,
    this.userCanBo,
    this.consistentWithReality,
    this.doesNotMatchReality,
    this.enhanceSoftSkills,
    this.strengThenForeignLanguages,
    this.enhanceTeamworkSkills,
    this.otherCommentsAboutStudents,
    this.suggestedComments,
    this.implementTheRulesWell,
    this.complyWithWorkingHours,
    this.attitude,
    this.positiveInWork,
    this.meetJobRequirements,
    this.spiritOfLearning,
    this.haveSuggestions,
    this.progressReport,
    this.completeTheWork,
    this.workResults,
    this.idHK
  });

  // Create fromMap method
  factory ResultEvaluation.fromMap(Map<String, dynamic> map) {
    return ResultEvaluation(
      sumScore: map['sumScore'],
      id: map['id'],
      timestamp: map['timestamp'],
      startDay: map['startDay'],
      endDay: map['endDay'],
      userStudent: UserModel.fromMap(map['userStudent']),
      companyIntern: CompanyIntern.fromMap(map['companyIntern']),
      userCanBo: UserModel.fromMap(map['userCanBo']),
      consistentWithReality: map['consistentWithReality'],
      doesNotMatchReality: map['doesNotMatchReality'],
      enhanceSoftSkills: map['enhanceSoftSkills'],
      strengThenForeignLanguages: map['strengThenForeignLanguages'],
      enhanceTeamworkSkills: map['enhanceTeamworkSkills'],
      otherCommentsAboutStudents: map['otherCommentsAboutStudents'],
      suggestedComments: map['suggestedComments'],
      implementTheRulesWell: map['implementTheRulesWell'],
      complyWithWorkingHours: map['complyWithWorkingHours'],
      attitude: map['attitude'],
      positiveInWork: map['positiveInWork'],
      meetJobRequirements: map['meetJobRequirements'],
      spiritOfLearning: map['spiritOfLearning'],
      haveSuggestions: map['haveSuggestions'],
      progressReport: map['progressReport'],
      completeTheWork: map['completeTheWork'],
      workResults: map['workResults'],
      idHK: map['idHK'],
    );
  }

  // Create toMap method
  Map<String, dynamic> toMap() {
    return {
      'sumScore': sumScore,
      'id': id,
      'timestamp': timestamp,
      'startDay': startDay,
      'endDay': endDay,
      'userStudent': userStudent?.toMap(),
      'companyIntern': companyIntern?.toMap(),
      'userCanBo': userCanBo?.toMap(),
      'consistentWithReality': consistentWithReality,
      'doesNotMatchReality': doesNotMatchReality,
      'enhanceSoftSkills': enhanceSoftSkills,
      'strengThenForeignLanguages': strengThenForeignLanguages,
      'enhanceTeamworkSkills': enhanceTeamworkSkills,
      'otherCommentsAboutStudents': otherCommentsAboutStudents,
      'suggestedComments': suggestedComments,
      'implementTheRulesWell': implementTheRulesWell,
      'complyWithWorkingHours': complyWithWorkingHours,
      'attitude': attitude,
      'positiveInWork': positiveInWork,
      'meetJobRequirements': meetJobRequirements,
      'spiritOfLearning': spiritOfLearning,
      'haveSuggestions': haveSuggestions,
      'progressReport': progressReport,
      'completeTheWork': completeTheWork,
      'workResults': workResults,
      'idHK': idHK,
    };
  }
}

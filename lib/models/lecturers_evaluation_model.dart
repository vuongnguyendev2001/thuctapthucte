class LecturersValuation {
  String? id;
  String? nameStudent;
  String? MSSV;
  String? correctFormat;
  String? wellPresented;
  String? haveAWorkSchedule;
  String? numberOfPracticeSessions;
  String? companyValuation;
  String? understandingAboutInternLocation;
  String? suitableMethod;
  String? reinforceTheory;
  String? suitableWorkout;
  String? practicalExperience;
  String? haveContributed;
  String? total;
  String? minusPoint;
  String? remainingPoints;
  String? lecturers;

  LecturersValuation({
    this.id,
    this.nameStudent,
    this.MSSV,
    this.correctFormat,
    this.wellPresented,
    this.haveAWorkSchedule,
    this.numberOfPracticeSessions,
    this.companyValuation,
    this.understandingAboutInternLocation,
    this.suitableMethod,
    this.reinforceTheory,
    this.suitableWorkout,
    this.practicalExperience,
    this.haveContributed,
    this.total,
    this.minusPoint,
    this.remainingPoints,
    this.lecturers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? '',
      'nameStudent': nameStudent ?? '',
      'MSSV': MSSV ?? '',
      'correctFormat': correctFormat ?? '',
      'wellPresented': wellPresented ?? '',
      'haveAWorkSchedule': haveAWorkSchedule ?? '',
      'numberOfPracticeSessions': numberOfPracticeSessions ?? '',
      'companyValuation': companyValuation ?? '',
      'understandingAboutInternLocation':
          understandingAboutInternLocation ?? '',
      'suitableMethod': suitableMethod ?? '',
      'reinforceTheory': reinforceTheory ?? '',
      'suitableWorkout': suitableWorkout ?? '',
      'practicalExperience': practicalExperience ?? '',
      'haveContributed': haveContributed ?? '',
      'total': total ?? '',
      'minusPoint': minusPoint ?? '',
      'remainingPoints': remainingPoints ?? '',
      'lecturers': lecturers ?? '',
    };
  }

  factory LecturersValuation.fromMap(Map<String, dynamic> map) {
    return LecturersValuation(
      id: map['id'] ?? '',
      nameStudent: map['nameStudent'] ?? '',
      MSSV: map['MSSV'] ?? '',
      correctFormat: map['correctFormat'] ?? '',
      wellPresented: map['wellPresented'] ?? '',
      haveAWorkSchedule: map['haveAWorkSchedule'] ?? '',
      numberOfPracticeSessions: map['numberOfPracticeSessions'] ?? '',
      companyValuation: map['companyValuation'] ?? '',
      understandingAboutInternLocation:
          map['understandingAboutInternLocation'] ?? '',
      suitableMethod: map['suitableMethod'] ?? '',
      reinforceTheory: map['reinforceTheory'] ?? '',
      suitableWorkout: map['suitableWorkout'] ?? '',
      practicalExperience: map['practicalExperience'] ?? '',
      haveContributed: map['haveContributed'] ?? '',
      total: map['total'] ?? '',
      minusPoint: map['minusPoint'] ?? '',
      remainingPoints: map['remainingPoints'] ?? '',
      lecturers: map['lecturers'] ?? '',
    );
  }
}

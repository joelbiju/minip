import 'dart:developer';

import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';

class SemesterModel {
  String sem;
  List<SubjectModel> subjects;
  List<List<SubjectModel?>> timeTable = [];

  SemesterModel({
    required this.sem,
    required this.subjects,
    this.timeTable = const [],
  });

  void initialise() {
    timeTable = List.generate(MAX_DAYS, (_) => List.filled(MAX_HOURS, null));
  }

  @override
  String toString() {
    return "Class: $sem\nSubjects: $subjects";
  }

  void getTimeTable() {
    print('\nTimetable of class: $sem');
    for (List<SubjectModel?> subjects in timeTable) {
      for (SubjectModel? subject in subjects) {
        if (subject != null) {
          log('${subject}\t');
        } else {
          log('null\t');
        }
      }
      print('');
    }
    print('');
  }

  String getName() {
    return sem;
  }

  List<SubjectModel> getSubjects() {
    return subjects;
  }
}

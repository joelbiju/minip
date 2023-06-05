import 'dart:io';
import 'package:timetablr/core/constants.dart' as constants;
import 'package:timetablr/domain/class/model/subject_model.dart';

class Faculty {
  final String name;
  final String code;
  final String department;
  List<SubjectModel> subjects;
  List<List<bool>> duty = [];
  List<List<SubjectModel?>> timeTable = [];
  int MAX_DAYS;
  int MAX_HOURS;
  Faculty({
    required this.department,
    required this.name,
    required this.code,
    required this.subjects,
    this.MAX_DAYS = constants.MAX_DAYS,
    this.MAX_HOURS = constants.MAX_HOURS,
  });
  void initialise() {
    duty = List.generate(MAX_DAYS, (_) => List.filled(MAX_HOURS, false));
    timeTable = List.generate(MAX_DAYS, (_) => List.filled(MAX_HOURS, null));
  }

  @override
  String toString() {
    return "Faculty: $name\nSubjects: $subjects";
  }

  void getTimeTable() {
    print('\nTime table of: $name');
    for (List<SubjectModel?> subjects in timeTable) {
      for (SubjectModel? s in subjects) {
        stdout.write('$s\t');
      }
      print('');
    }
    print('');
  }
}

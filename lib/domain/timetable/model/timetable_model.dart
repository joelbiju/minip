import 'package:timetablr/domain/class/model/subject_model.dart';

class TimetableModel {
  final List<SubjectModel?> timeTable;
  String? sem;
  String? dept;
  String? faculty;
  TimetableModel.classes({
    required this.timeTable,
    this.sem,
    this.dept,
  });
  TimetableModel.faculty({
    required this.timeTable,
    this.faculty,
  });
}

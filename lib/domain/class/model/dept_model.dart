import 'package:timetablr/domain/class/model/semester_model.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';

class DepartmentModel {
  final String name;
  final String shortName;
  final List<SemesterModel> semesters;
  final List<SubjectModel> subjects;
  final List<Faculty> faculties;
  DepartmentModel({
    required this.name,
    required this.shortName,
    required this.semesters,
    required this.subjects,
    required this.faculties,
  });
}

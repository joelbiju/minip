import 'package:timetablr/core/constants.dart';

class SubjectModel {
  final String name;
  final String code;
   int hours;
  int priority;
  SubjectModel(
      {required this.name,
      required this.code,
      required this.hours,
      this.priority = 1});
  @override
  String toString() {
    return '\nName: $name, Hours: $hours, Weight: $priority';
  }
}

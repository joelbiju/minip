import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timetablr/domain/class/model/semester_model.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';

import '../core/constants.dart';

class Service {
  List<Faculty> faculties;
  List<SemesterModel> Semesters;
  List<SemesterModel> classrooms = [];
  Service({
    required this.faculties,
    required this.Semesters,
  }) {
    classrooms = Semesters;
  }

  main(context) async {
    await Future.forEach(classrooms, (element) {
      element.initialise();
    });

    await Future.forEach(faculties, (element) {
      element.initialise();
    });
    classrooms.forEach((c) => generatetimeTable(c, context));
  }

  generatetimeTable(SemesterModel semesterModel, context) {
    final SemesterModel classroom = SemesterModel(
        sem: semesterModel.sem,
        subjects: semesterModel.subjects,
        timeTable: semesterModel.timeTable);
    int currentDay = 0;
    int currentHour = 0;
    int counter = 0;
    bool flag = false;

    List<SubjectModel> subjectQueue = [];
    for (SubjectModel subject in classroom.subjects) {
      for (int i = 0; i < subject.priority; i++) {
        subjectQueue.add(subject);
      }
    }

    int queueIndex = 0;

    while (currentDay < MAX_DAYS && checkComplete(subjectQueue)) {
      _SubjectModel currentSubject =
          _SubjectModel(subjectModel: subjectQueue[queueIndex]);
      Faculty faculty;
      try {
        faculty = faculties.firstWhere((f) {
          for (SubjectModel subject in f.subjects) {
            if (subject.name == currentSubject.name) {
              return true;
            }
          }
          return false;
        });
      } catch (e) {
        log('no faculty found for ${currentSubject.name}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No faculty found for ${currentSubject.name}'),
          ),
        );
        return;
      }

      if (currentSubject.hours > 0 && !faculty.duty[currentDay][currentHour]) {
        classroom.timeTable[currentDay][currentHour] =
            currentSubject.subjectModel;
        currentSubject.hours--;
        faculty.duty[currentDay][currentHour] = true;
        faculty.timeTable[currentDay][currentHour] =
            currentSubject.subjectModel;
        currentHour++;
        flag = true;
      }
      if (faculty.duty[currentDay][flag ? currentHour - 1 : currentHour]) {
        counter++;
        flag = false;
      }
      if (counter > 200000) {
        currentHour++;
      }
      if (currentHour >= MAX_HOURS) {
        currentHour = 0;
        currentDay++;
      }
      queueIndex = (queueIndex + 1) % subjectQueue.length;
    }
  }

  static bool checkComplete(List<SubjectModel> subjectQueue) {
    for (SubjectModel s in subjectQueue) {
      if (s.hours != 0) {
        return true;
      }
    }
    return false;
  }
}

class _SubjectModel {
  String name;
  String code;
  int hours;
  int priority;
  final SubjectModel subjectModel;
  _SubjectModel({required this.subjectModel})
      : name = subjectModel.name,
        code = subjectModel.code,
        hours = subjectModel.hours,
        priority = subjectModel.priority;

  @override
  String toString() {
    return '\nName: $name, Hours: $hours, Weight: $priority';
  }
}

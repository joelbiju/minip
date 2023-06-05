import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timetablr/domain/class/model/dept_model.dart';
import 'package:timetablr/domain/class/model/semester_model.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';
import 'package:timetablr/domain/login/model/user_model.dart';
import 'package:timetablr/domain/timetable/model/timetable_model.dart';

class TimetableRepo {
  static final TimetableRepo instance = TimetableRepo._internal();
  factory TimetableRepo() => instance;
  TimetableRepo._internal();
  ValueNotifier<List<TimetableModel>> classTimetableNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TimetableModel>> facultiesTimetableNotifier =
      ValueNotifier([]);
  saveTimetable(
      {required List<SemesterModel> classes,
      required List<Faculty> faculties,
      required DepartmentModel departmet}) async {
    await Future.forEach(classes, (_class) async {
      List<List<SubjectModel?>> subjectsList = _class.timeTable;

      List<Map<String, dynamic>> firestoreData = [];

      final CollectionReference subjectsCollection =
          FirebaseFirestore.instance.collection('users');
      await subjectsCollection
          .doc(UserModel.instance.userId)
          .collection('timetable')
          .doc(departmet.shortName)
          .set({'dept': departmet.shortName});
      for (List<SubjectModel?> list in subjectsList) {
        for (SubjectModel? subject in list) {
          if (subject != null) {
            firestoreData.add({
              'name': subject.name,
              'code': subject.code,
              'hours': subject.hours,
              'priority': subject.priority,
            });
          }
        }
      }

      await subjectsCollection
          .doc(UserModel.instance.userId)
          .collection('timetable')
          .doc(departmet.shortName)
          .collection('classes')
          .doc(_class.sem)
          .set({
        'data': firestoreData,
        'sem': _class.sem,
        'dept': departmet.shortName
      });
    });
    await Future.forEach(faculties, (faculty) {
      List<List<SubjectModel?>> subjectsList = faculty.timeTable;

      List<Map<String, dynamic>> firestoreData = [];

      for (List<SubjectModel?> list in subjectsList) {
        for (SubjectModel? subject in list) {
          if (subject != null) {
            firestoreData.add({
              'name': subject.name,
              'code': subject.code,
              'hours': subject.hours,
              'priority': subject.priority,
            });
          } else {
            firestoreData.add({'name': 'null'});
          }
        }
      }

      final CollectionReference subjectsCollection =
          FirebaseFirestore.instance.collection('users');

      subjectsCollection
          .doc(UserModel.instance.userId)
          .collection('timetable')
          .doc(departmet.shortName)
          .collection('faculties')
          .doc(faculty.name)
          .set({'data': firestoreData});
    });
  }

  Future<void> retrieveTimetable() async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    final departmentsDocs = await usersCollection
        .doc(UserModel.instance.userId)
        .collection('timetable')
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> departmentDoc
        in departmentsDocs.docs) {
      log('2');
      final department = departmentDoc.id;
      final semestersDocs = await usersCollection
          .doc(UserModel.instance.userId)
          .collection('timetable')
          .doc(department)
          .collection('classes')
          .get();

      for (var semesterDoc in semestersDocs.docs) {
        final semester = semesterDoc.id;
        final classTimetableDoc = await usersCollection
            .doc(UserModel.instance.userId)
            .collection('timetable')
            .doc(department)
            .collection('classes')
            .doc(semester)
            .get();

        final classTimetableData = classTimetableDoc.data();

        if (classTimetableData != null) {
          final timetableData = classTimetableData['data'] as List<dynamic>;

          List<SubjectModel?> subjectsList = [];

          for (var item in timetableData) {
            final subject = SubjectModel(
              name: item['name'],
              code: item['code'],
              hours: item['hours'],
              priority: item['priority'],
            );
            subjectsList.add(subject);
          }

          final timetableModel = TimetableModel.classes(
            timeTable: subjectsList,
            sem: semester,
            dept: department,
          );

          classTimetableNotifier.value.addAll([timetableModel]);
        }
      }

      // Retrieve faculties timetable for the department
      final facultiesTimetableDocs = await usersCollection
          .doc(UserModel.instance.userId)
          .collection('timetable')
          .doc(department)
          .collection('faculties')
          .get();

      for (var facultyDoc in facultiesTimetableDocs.docs) {
        final faculty = facultyDoc.id;

        final facultyTimetableDoc = await usersCollection
            .doc(UserModel.instance.userId)
            .collection('timetable')
            .doc(department)
            .collection('faculties')
            .doc(faculty)
            .get();

        final facultyTimetableData = facultyTimetableDoc.data();
        if (facultyTimetableData != null) {
          final timetableData = facultyTimetableData['data'] as List<dynamic>;

          List<SubjectModel?> subjectsList = [];

          for (var item in timetableData) {
            if (item['name'] == 'null') {
              subjectsList.add(null);
            } else {
              final subject = SubjectModel(
                name: item['name'],
                code: item['code'],
                hours: item['hours'],
                priority: item['priority'],
              );
              subjectsList.add(subject);
            }
          }

          final timetableModel = TimetableModel.faculty(
            timeTable: subjectsList,
            faculty: faculty,
          );

          facultiesTimetableNotifier.value.addAll([timetableModel]);
        }
      }
    }
    log(facultiesTimetableNotifier.value.toString());
    log(classTimetableNotifier.value.toString());
  }
}

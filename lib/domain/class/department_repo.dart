import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/model/dept_model.dart';
import 'package:timetablr/domain/class/model/semester_model.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/class/subject_repo.dart';
import 'package:timetablr/domain/faculty/faculty_repo.dart';

class DepartmentRepo {
  static final DepartmentRepo instance = DepartmentRepo._internal();
  factory DepartmentRepo() => instance;
  DepartmentRepo._internal();

  final ValueNotifier<List<DepartmentModel>> departments = ValueNotifier([]);

  addDepartment({required DepartmentModel department}) async {
    departments.value.add(department);

    await FirebaseFirestore.instance
        .collection('departments')
        .doc(department.shortName)
        .set({
      'name': department.name,
      'shortName': department.shortName,
    });
    for (int i = 1; i <= 8; i++) {
      departments.value.last.semesters.add(
        SemesterModel(sem: 'Semester$i', subjects: []),
      );
      FirebaseFirestore.instance
          .collection('departments')
          .doc(department.shortName)
          .collection(department.shortName)
          .doc('Semester$i')
          .set({
        'sem': 'Semester$i',
      });
    }
    departments.notifyListeners();
  }

  getDepartments() async {
    departments.value.clear();

    final querySnapshot =
        await FirebaseFirestore.instance.collection('departments').get();

    for (var doc in querySnapshot.docs) {
      departments.value.add(DepartmentModel(
        name: doc['name'],
        shortName: doc['shortName'],
        semesters: [],
        subjects: [],
        faculties: [],
      ));
    }

    await Future.forEach(departments.value, (element) async {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('departments')
          .doc(element.shortName)
          .collection(element.shortName)
          .get();

      for (var doc in querySnapshot.docs) {
        element.semesters.add(
          SemesterModel(
            sem: doc['sem'],
            subjects: [],
          ),
        );
      }
    });
    int i = 0;
    await Future.wait(departments.value.map((dept) async {
      FacultyRepo.instance.getFaculty(i++);
      for (var sem in dept.semesters) {
        SubjectRepo.instance.getSubjects(
          dept: dept.shortName,
          sem: sem.sem,
          deptIndex: departments.value.indexOf(dept),
          semIndex: dept.semesters.indexOf(sem),
        );
      }
    }));

    departments.notifyListeners();
  }
}

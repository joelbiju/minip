import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/dept_model.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/faculty/model/faculty_model.dart';

class FacultyRepo {
  static final FacultyRepo instance = FacultyRepo._internal();
  factory FacultyRepo() => instance;
  FacultyRepo._internal();
  addFaculty({required DepartmentModel dept, required Faculty faculty}) async {
    await FirebaseFirestore.instance
        .collection('departments')
        .doc(dept.shortName)
        .collection('faculties')
        .doc(faculty.code)
        .set({
      'name': faculty.name,
      'code': faculty.code,
      'department': dept.shortName,
    });
    await Future.forEach(faculty.subjects, (element) {
      FirebaseFirestore.instance
          .collection('departments')
          .doc(dept.shortName)
          .collection('faculties')
          .doc(faculty.code)
          .collection('subjects')
          .doc(element.code)
          .set({
        'name': element.name,
        'code': element.code,
        'hours': element.hours,
      });
    });
  }

  getFaculty(int i) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('departments')
        .doc(DepartmentRepo.instance.departments.value[i].shortName)
        .collection('faculties')
        .get();
    for (var doc in querySnapshot.docs) {
      DepartmentRepo.instance.departments.value[i].faculties.add(Faculty(
        name: doc['name'],
        code: doc['code'],
        department: doc['department'],
        subjects: [],
      ));
    }
    await Future.forEach(DepartmentRepo.instance.departments.value[i].faculties,
        (element) async {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('departments')
          .doc(DepartmentRepo.instance.departments.value[i].shortName)
          .collection('faculties')
          .doc(element.code)
          .collection('subjects')
          .get();
      for (var doc in querySnapshot.docs) {
        element.subjects.add(SubjectModel(
          name: doc['name'],
          code: doc['code'],
          hours: doc['hours'],
        ));
      }

    });
  }

  deleteFaculty({
    required String dept,
    required Faculty faculty,
  }) async {
    await Future.forEach(faculty.subjects, (element) async {
      await FirebaseFirestore.instance
          .collection('departments')
          .doc(dept)
          .collection('faculties')
          .doc(faculty.code)
          .collection('subjects')
          .doc(element.code)
          .delete();
    });
    await FirebaseFirestore.instance
        .collection('departments')
        .doc(dept)
        .collection('faculties')
        .doc(faculty.code)
        .delete();
  }

  editFaculty({
    required DepartmentModel dept,
    required Faculty faculty,
    required Faculty newFaculty,
  }) async {
    await deleteFaculty(dept: dept.shortName, faculty: faculty);
    await addFaculty(dept: dept, faculty: newFaculty);
  }
}

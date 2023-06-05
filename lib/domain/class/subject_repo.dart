import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/presentation/class/widgets/add_subject.dart';

class SubjectRepo {
  static final SubjectRepo instance = SubjectRepo._internal();
  factory SubjectRepo() => instance;
  SubjectRepo._internal();

  addSubjects(
      {required String dept,
      required String sem,
      required List<SubjectModel> subjects}) async {
    subjects.forEach((element) async {
      if (element.code[2].toUpperCase() == 'L') {
        element.priority = 3;
      }
      await FirebaseFirestore.instance
          .collection('departments')
          .doc(dept)
          .collection(dept)
          .doc(sem)
          .collection(sem)
          .doc(element.code)
          .set({
        'name': element.name,
        'code': element.code,
        'hours': element.hours,
        'priority': element.priority,
      });
    });
  }

  getSubjects(
      {required String dept,
      required String sem,
      required int deptIndex,
      required int semIndex}) async {
    await FirebaseFirestore.instance
        .collection('departments')
        .doc(dept)
        .collection(dept)
        .doc(sem)
        .collection(sem)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final subject = SubjectModel(
          name: doc['name'],
          code: doc['code'],
          hours: doc['hours'],
          priority: doc['priority'],
        );
        DepartmentRepo.instance.departments.value[deptIndex].subjects
            .add(subject);
        DepartmentRepo
            .instance.departments.value[deptIndex].semesters[semIndex].subjects
            .add(
          subject,
        );
      }
    });
  }

  editSubject({
    required String dept,
    required String sem,
    required String oldCode,
    required SubjectModel newSubject,
  }) async {
    if (oldCode == newSubject.code) {
      await FirebaseFirestore.instance
          .collection('departments')
          .doc(dept)
          .collection(dept)
          .doc(sem)
          .collection(sem)
          .doc(oldCode)
          .update({
        'name': newSubject.name,
        'code': newSubject.code,
        'hours': newSubject.hours,
        'priority': newSubject.priority,
      });
    } else {
      if (newSubject.code[2].toUpperCase() == 'L') {
        newSubject.priority = 3;
      }
      await FirebaseFirestore.instance
          .collection('departments')
          .doc(dept)
          .collection(dept)
          .doc(sem)
          .collection(sem)
          .doc(oldCode)
          .delete();
      await FirebaseFirestore.instance
          .collection('departments')
          .doc(dept)
          .collection(dept)
          .doc(sem)
          .collection(sem)
          .doc(newSubject.code)
          .set({
        'name': newSubject.name,
        'code': newSubject.code,
        'hours': newSubject.hours,
        'priority': newSubject.priority,
      });
    }
  }

  deleteSubject({
    required String dept,
    required String sem,
    required String oldCode,
  }) async {
    await FirebaseFirestore.instance
        .collection('departments')
        .doc(dept)
        .collection(dept)
        .doc(sem)
        .collection(sem)
        .doc(oldCode)
        .delete();
  }
}

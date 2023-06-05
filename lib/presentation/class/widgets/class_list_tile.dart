import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timetablr/domain/class/department_repo.dart';

class ClassListTile extends StatelessWidget {
  const ClassListTile(
      {super.key,
      required this.onTap,
      required this.semIndex,
      required this.deptIndex});
  final int semIndex;
  final int deptIndex;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: DepartmentRepo.instance.departments,
        builder: (context, value, _) {
          final semester = DepartmentRepo
              .instance.departments.value[deptIndex].semesters[semIndex];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              onTap: onTap,
              tileColor: Colors.white12,
              title: Text(semester.sem,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'popins',
                    letterSpacing: 1.5,
                  )),
              subtitle: Text(
                semester.subjects.join(', '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  height: 2,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'popins',
                  wordSpacing: 1.5,
                  letterSpacing: 1.5,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        });
  }
}

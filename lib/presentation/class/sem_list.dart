import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/dept_model.dart';
import 'package:timetablr/domain/class/model/semester_model.dart';
import 'package:timetablr/presentation/class/subject_list.dart';
import 'package:timetablr/presentation/class/widgets/add_subject.dart';
import 'package:timetablr/presentation/class/widgets/class_list_tile.dart';
import 'package:timetablr/presentation/common/appbar.dart';
import 'package:timetablr/presentation/common/floating_button.dart';

class SemsterList extends StatelessWidget {
  const SemsterList({super.key, required this.deptIndex});
  final int deptIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(title: 'Semesters'),
      body: ValueListenableBuilder(
          valueListenable: DepartmentRepo.instance.departments,
          builder: (context, value, _) {
            return ListView.separated(
                itemBuilder: (context, semIndex) {
                  return ClassListTile(
                    semIndex: semIndex,
                    deptIndex: deptIndex,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SubjectList(
                                departmentName: DepartmentRepo.instance
                                    .departments.value[deptIndex].shortName,
                                deptIndex: deptIndex,
                                semIndex: semIndex,
                              )));
                    },
                  );
                },
                separatorBuilder: (context, index) => kheight10,
                itemCount: DepartmentRepo
                    .instance.departments.value[deptIndex].semesters.length);
          }),
    );
  }
}

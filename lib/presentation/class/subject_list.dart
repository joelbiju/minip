import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timetablr/core/colors.dart';
import 'package:timetablr/core/constants.dart';
import 'package:timetablr/domain/class/department_repo.dart';
import 'package:timetablr/domain/class/model/subject_model.dart';
import 'package:timetablr/domain/class/subject_repo.dart';
import 'package:timetablr/presentation/class/widgets/add_subject.dart';
import 'package:timetablr/presentation/class/widgets/heading_with_textfield.dart';
import 'package:timetablr/presentation/common/appbar.dart';
import 'package:timetablr/presentation/common/floating_button.dart';
import 'package:timetablr/presentation/homepage/widgets/submitbtn.dart';

class SubjectList extends StatelessWidget {
  SubjectList(
      {super.key,
      required this.semIndex,
      required this.departmentName,
      required this.deptIndex});
  final String departmentName;
  final int semIndex;
  final int deptIndex;
  final courseController = TextEditingController();
  final codeController = TextEditingController();
  final hourController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: DepartmentRepo.instance.departments,
        builder: (context, value, _) {
          final semester = value[deptIndex].semesters[semIndex];
          return Scaffold(
            floatingActionButton: semester.subjects.isEmpty
                ? FloatingButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddSubjects(
                            departmentName: departmentName,
                            semester: semester.sem),
                      ));
                    },
                    icon: Icons.add)
                : null,
            appBar: appbar(title: 'Subjects'),
            body: semester.subjects.isEmpty
                ? SizedBox()
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final subject = semester.subjects[index];
                            log(subject.toString());
                            return GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: primaryColor,
                                      title: Text("Delete Subject",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      content: Row(
                                        children: [
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          secondaryColor)),
                                              onPressed: () async {
                                                await SubjectRepo.instance
                                                    .deleteSubject(
                                                        dept: departmentName,
                                                        oldCode: semester
                                                            .subjects[index]
                                                            .code,
                                                        sem: semester.sem);
                                                await DepartmentRepo.instance
                                                    .getDepartments();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Yes')),
                                          kwidth20,
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          secondaryColor)),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('No')),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  '${subject.name}- ${subject.code}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Hours : ${subject.hours.toString()}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: GestureDetector(
                                  child: Icon(Icons.edit, color: Colors.white),
                                  onTap: () {
                                    courseController.text = subject.name;
                                    codeController.text = subject.code;
                                    hourController.text =
                                        subject.hours.toString();
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              backgroundColor: primaryColor,
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFieldWithHeading(
                                                    heading: 'Edit Subject',
                                                    hintText: '',
                                                    controller:
                                                        courseController,
                                                    hourHint: '',
                                                    courseCodeHint: '',
                                                    codeController:
                                                        codeController,
                                                    hourController:
                                                        hourController,
                                                  ),
                                                  kheight20,
                                                  EvenOdd(
                                                    colorbox: primaryColor,
                                                    textData:
                                                        const Text('update'),
                                                    pressed: () async {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      final SubjectModel
                                                          updatedSubject =
                                                          SubjectModel(
                                                        name: courseController
                                                            .text,
                                                        code:
                                                            codeController.text,
                                                        hours: int.parse(
                                                            hourController
                                                                .text),
                                                      );
                                                      await SubjectRepo.instance
                                                          .editSubject(
                                                        dept: departmentName,
                                                        sem: semester.sem,
                                                        oldCode: semester
                                                            .subjects[index]
                                                            .code,
                                                        newSubject:
                                                            updatedSubject,
                                                      );
                                                      await DepartmentRepo
                                                          .instance
                                                          .getDepartments();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ],
                                              ),
                                            ));
                                  },
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.white54,
                              ),
                          itemCount: semester.subjects.length),
                    ),
                  ),
          );
        });
  }
}
